import 'dart_annotation.dart';
import 'dart_field.dart';

class DartClass {
  final String name;
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.name,
    required this.annotations,
    required this.fields,
  });
}
