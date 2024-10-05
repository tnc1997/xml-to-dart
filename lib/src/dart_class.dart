import 'dart_field.dart';

class DartClass {
  final String name;
  final String? namespace;
  final Set<DartField> dartFields;

  const DartClass({
    required this.name,
    this.namespace,
    required this.dartFields,
  });

  @override
  int get hashCode {
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DartClass &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}
