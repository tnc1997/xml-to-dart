import 'dart_class.dart';
import 'dart_field_reducer.dart';

class DartClassReducer {
  final DartFieldReducer fieldReducer;

  const DartClassReducer({
    this.fieldReducer = const DartFieldReducer(),
  });

  DartClass combine(
    DartClass a,
    DartClass b,
  ) {
    final fields = a.fields.toList();
    for (final field in b.fields) {
      final index = fields.indexWhere(
        (element) {
          return element.name == field.name;
        },
      );

      if (index >= 0) {
        fields[index] = fieldReducer.combine(fields[index], field);
      } else {
        fields.add(field);
      }
    }

    return DartClass(
      name: a.name,
      annotations: a.annotations.toList(),
      fields: fields,
    );
  }
}
