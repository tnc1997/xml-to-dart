import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_field_reducer.dart';
import 'dart_type_reducer.dart';

class DartClassReducer {
  final DartFieldReducer fieldReducer;
  final DartTypeReducer typeReducer;

  const DartClassReducer({
    this.fieldReducer = const DartFieldReducer(),
    this.typeReducer = const DartTypeReducer(),
  });

  DartClass combine(
    DartClass a,
    DartClass b,
  ) {
    final fields = <String, DartField>{};
    for (final entry in a.fields.entries) {
      final field = b.fields[entry.key];
      if (field != null) {
        fields[entry.key] = DartField(
          name: entry.value.name,
          annotations: entry.value.annotations.toList(),
          type: typeReducer.combine(
            entry.value.type,
            field.type,
          ),
        );
      } else {
        fields[entry.key] = entry.value;
      }
    }

    return DartClass(
      name: a.name,
      annotations: a.annotations.toList(),
      fields: fields,
    );
  }
}
