import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:nenuphar_cli/src/models/daemon_event.dart';
import 'package:nenuphar_cli/src/models/daemon_message.dart';

///
/// Helper class to communicate with the dart_frog daemon
///
class DartFrogDaemonClient {
  DartFrogDaemonClient({
    required FileSystem fileSystem,
    required Logger logger,
    required Future<void> Function() onRouteChanged,
  })  : _fileSystem = fileSystem,
        _logger = logger,
        _onRouteChanged = onRouteChanged;

  final FileSystem _fileSystem;

  final Logger _logger;

  /// Callback called when the route configuration changed
  final Future<void> Function() _onRouteChanged;

  /// The daemon process instance used to communicate with the daemon
  late Process _daemonProcess;

  /// Daemon process stdout subscription
  late StreamSubscription<String> _stdoutSouscription;

  /// Daemon process stderr subscription
  late StreamSubscription<String> _stderrSouscription;

  /// Completer used to know when the daemon is ready
  final Completer<bool> _daemonReady = Completer();

  /// Completer used to know when the watcher is started
  final Completer<String> _watcherId = Completer();

  /// Completer used to know when the daemon should stop
  final Completer<bool> _end = Completer();

  /// Boolean used to know if the daemon is generating the openapi file
  /// This is used to avoid multiple generation at the same time
  bool _generating = false;

  /// Starts the daemon process
  void start() {
    Process.start(
      'dart_frog',
      ['daemon'],
      workingDirectory: _fileSystem.currentDirectory.path,
    ).then((process) {
      _daemonProcess = process;
      _logger.info('dart_frog daemon PID: ${_daemonProcess.pid}');
      _listenDaemonOutput();
    });
  }

  /// Stops the daemon process and clean up resources
  Future<bool> stop() async {
    await stopWatching();

    await _stdoutSouscription.cancel();
    await _stderrSouscription.cancel();

    _end.complete(true);

    return _daemonProcess.kill();
  }

  /// This method is called to wait until the daemon ends
  Future<bool> waitForTheEnd() async => _end.future;

  /// This method is called to wait until the daemon is ready
  Future<bool> waitForReady() async => _daemonReady.future;

  /// Listen for daemon output using stdout and stderr
  void _listenDaemonOutput() {
    _logger.info('Listening for dart_frog daemon output...');
    // souscription cancelled in the run method
    // ignore: cancel_subscriptions
    _stdoutSouscription =
        _daemonProcess.stdout.transform(utf8.decoder).listen(_onEvents);
    // souscription cancelled in the run method
    // ignore: cancel_subscriptions
    _stderrSouscription =
        _daemonProcess.stderr.transform(utf8.decoder).listen(_onErrors);
  }

  /// Send `watcherStart` command to the daemon
  void startWatching() {
    _logger.info('Starting to watch route modifications...');
    final startWatchMessage = DartFrogDaemonMessage(
      method: DartFrogDaemonMessage.startWatchMethod,
      params: DartFrogDaemonMessageParams(
        workingDirectory: _fileSystem.currentDirectory.path,
      ),
      id: pid.toString(),
    );

    final jsonCommand = jsonEncode([startWatchMessage.toJson()]);

    sendCommand(jsonCommand);
  }

  /// Send `watcherStop` command to the daemon
  Future<void> stopWatching() async {
    _logger.info('Stopping to watch route modifications...');

    if (!_watcherId.isCompleted) {
      _logger.info('No watcher started');
      return;
    }

    final watcherId = await _watcherId.future;

    final stopWatchMessage = DartFrogDaemonMessage(
      method: DartFrogDaemonMessage.stopWatchMethod,
      params: DartFrogDaemonMessageParams(
        watcherId: watcherId,
      ),
      id: pid.toString(),
    );

    final jsonCommand = jsonEncode([stopWatchMessage.toJson()]);

    sendCommand(jsonCommand);
  }

  /// Sends a command to the daemon
  void sendCommand(String command) {
    _logger.info('Sending command: $command');
    _daemonProcess.stdin.writeln(command.trim());
    _daemonProcess.stdin.flush();
  }

  /// Logs any error received from the daemon
  void _onErrors(String error) {
    _logger.err(
      'Received error: $error',
      style: (m) => red.wrap(styleBold.wrap(m)),
    );
  }

  /// Handle RAW events String received from the daemon
  Future<void> _onEvents(String events) async {
    events.split('\n').where((line) => line.isNotEmpty).forEach(_onEventLine);
  }

  /// Handle a single event String received from the daemon
  void _onEventLine(String line) {
    _logger.info('Received event [RAW]: $line');
    final eventList = jsonDecode(line.trim()) as List<dynamic>;
    eventList.map(DartFrogDaemonEvent.fromJson).forEach(_onEvent);
  }

  /// Handle a single deserialized event received from the daemon
  Future<void> _onEvent(DartFrogDaemonEvent event) async {
    _logger.info(
      'Received event: ${event.event}',
      style: (m) => green.wrap(styleBold.wrap(m)),
    );

    switch (event.event) {
      case DartFrogDaemonEvent.eventDaemonReady:
        _daemonReady.complete(true);
      case DartFrogDaemonEvent.eventWatcherStarted:
        _watcherId.complete(event.params?.watcherId);
      case DartFrogDaemonEvent.eventWatcherStopped:
        _logger.info('Watcher stopped');
      case DartFrogDaemonEvent.eventRouteConfigurationChanged:
        _logger.info(
          'Route configuration changed, regenerating openapi file...',
        );
        if (_generating) {
          _logger.info('Already generating, skipping...');
          return;
        }
        _generating = true;
        await _onRouteChanged();
        _generating = false;
    }
  }
}
