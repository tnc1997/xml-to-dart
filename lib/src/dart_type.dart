class DartType {
  final String name;
  final NullabilitySuffix nullabilitySuffix;

  const DartType({
    required this.name,
    this.nullabilitySuffix = NullabilitySuffix.none,
  });

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartType &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  DartType copyWith({
    NullabilitySuffix? nullabilitySuffix,
  }) {
    return DartType(
      name: name,
      nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
    );
  }

  @override
  String toString() {
    return name;
  }
}

class BoolDartType extends DartType {
  const BoolDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'bool',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class DateTimeDartType extends DartType {
  const DateTimeDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'DateTime',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class DoubleDartType extends DartType {
  const DoubleDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'double',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class IntDartType extends DartType {
  const IntDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'int',
          nullabilitySuffix: nullabilitySuffix,
        );
}

class StringDartType extends DartType {
  const StringDartType({
    NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
  }) : super(
          name: 'String',
          nullabilitySuffix: nullabilitySuffix,
        );
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
