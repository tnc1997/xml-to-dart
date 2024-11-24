import 'dart_field.dart';
import 'dart_type.dart';
import 'dart_type_reducer.dart';
import 'nullability_suffix.dart';

abstract class DartFieldReducer {
  DartField combine(
    DartField a,
    DartField b,
  );
}

class XmlToDartDartFieldReducer implements DartFieldReducer {
  final DartTypeReducer typeReducer;

  const XmlToDartDartFieldReducer({
    this.typeReducer = const DartTypeReducer(),
  });

  @override
  DartField combine(
    DartField a,
    DartField b,
  ) {
    return DartField(
      name: a.name,
      annotations: a.annotations.toList(),
      type: DartType(
        name: 'List',
        nullabilitySuffix: NullabilitySuffix.none,
        typeArguments: [
          typeReducer.combine(
            a.type.name == 'List' ? a.type.typeArguments.single : a.type,
            b.type.name == 'List' ? b.type.typeArguments.single : b.type,
          ),
        ],
      ),
    );
  }
}
