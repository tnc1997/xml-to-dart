import 'package:recase/recase.dart';

import 'dart_field.dart';

typedef DartFieldNamer = String Function(DartField dartField,);

String dartFieldNamer(DartField dartField,) {
  if (dartField is XmlAttributeDartField) {
    return dartField.name.camelCase;
  } else if (dartField is XmlCDATADartField) {
    return 'cdata';
  } else if (dartField is XmlElementDartField) {
    return dartField.name.camelCase;
  } else if (dartField is XmlTextDartField) {
    return 'text';
  } else {
    throw ArgumentError.value(dartField, 'dartField');
  }
}
