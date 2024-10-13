class DartType {
  final String name;
  final NullabilitySuffix nullabilitySuffix;
  final List<DartType> typeArguments;

  const DartType({
    required this.name,
    this.nullabilitySuffix = NullabilitySuffix.none,
    this.typeArguments = const [],
  });

  factory DartType.fromValue(
    String value,
  ) {
    if (int.tryParse(value) != null) {
      return const DartType(
        name: 'int',
      );
    } else if (double.tryParse(value) != null) {
      return const DartType(
        name: 'double',
      );
    } else if (DateTime.tryParse(value) != null) {
      return const DartType(
        name: 'DateTime',
      );
    } else if (value == 'true' || value == 'false') {
      return const DartType(
        name: 'bool',
      );
    } else {
      return const DartType(
        name: 'String',
      );
    }
  }

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

/// Suffix indicating the nullability of a type.
///
/// This enum describes whether a `?` would be used at the end of the canonical representation of a type. It's subtly different the notions of "nullable" and "non-nullable" defined by the spec. For example, the type `Null` is nullable, even though it lacks a trailing `?`.
enum NullabilitySuffix {
  /// An indication that the canonical representation of the type under consideration ends with `?`. Types having this nullability suffix should be interpreted as being unioned with the Null type.
  question,

  /// An indication that the canonical representation of the type under consideration does not end with `?`.
  none,
}

class DartTypeReducer {
  const DartTypeReducer();

  DartType combine(
    DartType a,
    DartType b,
  ) {
    String name;
    if (a.name == b.name) {
      name = a.name;
    } else if (a.name == 'int' && b.name == 'double') {
      name = 'double';
    } else if (a.name == 'double' && b.name == 'int') {
      name = 'double';
    } else {
      name = 'String';
    }

    NullabilitySuffix nullabilitySuffix;
    if (a.nullabilitySuffix == b.nullabilitySuffix) {
      nullabilitySuffix = a.nullabilitySuffix;
    } else if (a.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else if (b.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else {
      nullabilitySuffix = NullabilitySuffix.none;
    }

    return DartType(
      name: name,
      nullabilitySuffix: nullabilitySuffix,
    );
  }
}
