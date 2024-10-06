class DartType {
  final String name;
  final NullabilitySuffix nullabilitySuffix;

  const DartType({
    required this.name,
    this.nullabilitySuffix = NullabilitySuffix.none,
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
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartType && name == other.name;
  }

  DartType copyWith({
    String? name,
    NullabilitySuffix? nullabilitySuffix,
  }) {
    return DartType(
      name: name ?? this.name,
      nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
    );
  }

  DartType mergeWith(
    DartType other,
  ) {
    String name;
    if (this.name == other.name) {
      name = this.name;
    } else if (this.name == 'int' && other.name == 'double') {
      name = 'double';
    } else if (this.name == 'double' && other.name == 'int') {
      name = 'double';
    } else {
      name = 'String';
    }

    NullabilitySuffix nullabilitySuffix;
    if (this.nullabilitySuffix == other.nullabilitySuffix) {
      nullabilitySuffix = this.nullabilitySuffix;
    } else if (this.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else if (other.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else {
      nullabilitySuffix = NullabilitySuffix.none;
    }

    return DartType(
      name: name,
      nullabilitySuffix: nullabilitySuffix,
    );
  }

  @override
  String toString() {
    switch (nullabilitySuffix) {
      case NullabilitySuffix.question:
        return '$name?';
      case NullabilitySuffix.none:
        return name;
    }
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
