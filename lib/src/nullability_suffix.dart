/// Suffix indicating the nullability of a type.
///
/// This enum describes whether a `?` would be used at the end of the canonical representation of a type. It's subtly different the notions of "nullable" and "non-nullable" defined by the spec. For example, the type `Null` is nullable, even though it lacks a trailing `?`.
enum NullabilitySuffix {
  /// An indication that the canonical representation of the type under consideration ends with `?`. Types having this nullability suffix should be interpreted as being unioned with the Null type.
  question,

  /// An indication that the canonical representation of the type under consideration does not end with `?`.
  none,
}
