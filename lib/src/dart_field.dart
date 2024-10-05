
import 'dart_type.dart';

abstract class DartField {
  final DartType dartType;

  const DartField({
    required this.dartType,
  });
}

class XmlAttributeDartField extends DartField {
  final String name;
  final String? namespace;

  const XmlAttributeDartField({
    required this.name,
    this.namespace,
    required DartType dartType,
  }) : super(
    dartType: dartType,
  );

  @override
  int get hashCode {
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is XmlAttributeDartField &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}

class XmlCDATADartField extends DartField {
  const XmlCDATADartField({
    required DartType dartType,
  }) : super(
    dartType: dartType,
  );
}

class XmlElementDartField extends DartField {
  final String name;
  final String? namespace;

  const XmlElementDartField({
    required this.name,
    this.namespace,
    required DartType dartType,
  }) : super(
    dartType: dartType,
  );

  @override
  int get hashCode {
    return name.hashCode ^ namespace.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is XmlElementDartField &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            namespace == other.namespace;
  }

  @override
  String toString() {
    return name;
  }
}

class XmlTextDartField extends DartField {
  const XmlTextDartField({
    required DartType dartType,
  }) : super(
    dartType: dartType,
  );
}
