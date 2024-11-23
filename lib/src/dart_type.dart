import 'nullability_suffix.dart';

class DartType {
  final String name;
  final NullabilitySuffix nullabilitySuffix;
  final List<DartType> typeArguments;

  const DartType({
    required this.name,
    this.nullabilitySuffix = NullabilitySuffix.none,
    this.typeArguments = const [],
  });

  @override
  String toString() {
    final buffer = StringBuffer(name);

    if (typeArguments.isNotEmpty) {
      buffer.write('<');

      for (var i = 0; i < typeArguments.length; i++) {
        buffer.write(typeArguments[i]);

        if (i < typeArguments.length - 1) {
          buffer.write(', ');
        }
      }

      buffer.write('>');
    }

    if (nullabilitySuffix == NullabilitySuffix.question) {
      buffer.write('?');
    }

    return buffer.toString();
  }
}
