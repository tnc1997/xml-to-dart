import 'dart_annotation.dart';
import 'dart_type.dart';

class DartField {
  final String name;
  final DartType type;
  final List<DartAnnotation> annotations;

  const DartField({
    required this.name,
    required this.type,
    this.annotations = const [],
  });
}
