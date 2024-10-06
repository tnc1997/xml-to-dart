import 'dart_annotation.dart';
import 'dart_type.dart';

class DartField {
  final String name;
  final List<DartAnnotation> annotations;
  final DartType type;

  const DartField({
    required this.name,
    required this.annotations,
    required this.type,
  });

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartField && name == other.name;
  }

  @override
  String toString() {
    return name;
  }
}
