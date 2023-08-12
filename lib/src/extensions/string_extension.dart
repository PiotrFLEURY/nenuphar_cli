final pathParamRegex = RegExp(r'\{[a-zA-z0-9]*\}');

extension StringExtention on String {
  bool endsWithPathParam() {
    return isNotEmpty &&
        contains('/') &&
        trim() != '/' &&
        pathParamRegex.hasMatch(
          split('/').where((part) => part.isNotEmpty).last,
        );
  }
}
