import 'package:build/build.dart';

class XmlToDartBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.xml': [
      '.dart',
    ],
  };

  const XmlToDartBuilder();

  @override
  Future<void> build(
      BuildStep buildStep,
      ) {
    throw UnimplementedError();
  }
}
