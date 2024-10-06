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

  DartField copyWith({
    String? name,
    List<DartAnnotation>? annotations,
    DartType? type,
  }) {
    return DartField(
      name: name ?? this.name,
      annotations: annotations ?? this.annotations,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return name;
  }
}
