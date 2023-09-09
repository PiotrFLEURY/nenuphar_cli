import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:nenuphar_cli/src/helpers/dart_frog_daemon_client.dart';

/// {@template sample_command}
///
/// `nenuphar watch`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class WatchCommand extends Command<int> {
  /// {@macro sample_command}
  WatchCommand({
    required Logger logger,
    required FileSystem fileSystem,
    required Future<void> Function() onRouteChanged,
  })  : _logger = logger,
        _fileSystem = fileSystem,
        _onRouteChanged = onRouteChanged;

  @override
  String get description => 'Sub command to watch route modifications';

  @override
  String get name => 'watch';

  final Logger _logger;

  final FileSystem _fileSystem;

  final Future<void> Function() _onRouteChanged;

  @override
  Future<int> run() async {
    _logger.info('Starting dart_frog daemon...');

    final daemon = DartFrogDaemonClient(
      fileSystem: _fileSystem,
      logger: _logger,
      onRouteChanged: _onRouteChanged,
    )..start();

    await daemon.waitForReady();

    // Start watching route modifications
    daemon.startWatching();

    // Listen for user stdin input command
    _logger.info('Listening for user input...');

    final stdinSouscription = stdin.transform(utf8.decoder).listen((input) {
      _logger.info('Received user input: $input');
      if (input.trim() == 'exit') {
        daemon.stop();
      } else {
        daemon.sendCommand(input);
      }
    });

    await daemon.waitForTheEnd();

    await stdinSouscription.cancel();

    _logger.info('Ending nenuphar watch...');

    return ExitCode.success.code;
  }
}
