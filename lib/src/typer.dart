import 'dart_type.dart';

typedef Typer = DartType Function(
  String value,
);

DartType typer(
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
