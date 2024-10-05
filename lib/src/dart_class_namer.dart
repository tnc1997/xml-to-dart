import 'package:recase/recase.dart';

import 'dart_class.dart';

typedef DartClassNamer = String Function(DartClass dartClass,);

String dartClassNamer(DartClass dartClass,) {
  return dartClass.name.pascalCase;
}
