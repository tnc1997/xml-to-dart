import 'dart_type.dart';

typedef DartTyper = DartType Function(String value,);

DartType dartTyper(String value,) {
  if (int.tryParse(value) != null) {
    return const IntDartType();
  } else if (double.tryParse(value) != null) {
    return const DoubleDartType();
  } else if (DateTime.tryParse(value) != null) {
    return const DateTimeDartType();
  } else if (value == 'true' || value == 'false') {
    return const BoolDartType();
  } else {
    return const StringDartType();
  }
}
