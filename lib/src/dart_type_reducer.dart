import 'dart_type.dart';
import 'nullability_suffix.dart';

class DartTypeReducer {
  const DartTypeReducer();

  DartType combine(
    DartType a,
    DartType b,
  ) {
    final String name;
    if (a.name == b.name) {
      name = a.name;
    } else if (a.name == 'List' || b.name == 'List') {
      name = 'List';
    } else {
      name = 'String';
    }

    final NullabilitySuffix nullabilitySuffix;
    if (a.nullabilitySuffix == b.nullabilitySuffix) {
      nullabilitySuffix = a.nullabilitySuffix;
    } else if (a.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else if (b.nullabilitySuffix == NullabilitySuffix.question) {
      nullabilitySuffix = NullabilitySuffix.question;
    } else {
      nullabilitySuffix = NullabilitySuffix.none;
    }

    final typeArguments = <DartType>[];
    if (a.name == 'List' || b.name == 'List') {
      typeArguments.add(
        combine(
          a.name == 'List' ? a.typeArguments.single : a,
          b.name == 'List' ? b.typeArguments.single : b,
        ),
      );
    }

    return DartType(
      name: name,
      nullabilitySuffix: nullabilitySuffix,
      typeArguments: typeArguments,
    );
  }
}
