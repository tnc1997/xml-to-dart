import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_type.dart';
import 'namer.dart';

class DartField {
  final String name;
  final List<DartAnnotation> annotations;
  final DartType type;

  const DartField({
    required this.name,
    required this.annotations,
    required this.type,
  });

  factory DartField.fromXmlEventAttribute(
    XmlEventAttribute attribute,
  ) {
    return DartField(
      name: camelCaseNamer(
        attribute.localName,
        attribute.namespaceUri,
      ),
      annotations: [
        XmlAttributeDartAnnotation.fromXmlEventAttribute(
          attribute,
        ),
      ],
      type: DartType.fromValue(
        attribute.value,
      ),
    );
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartField && name == other.name;
  }

  DartField copyWith({
    String? name,
    List<DartAnnotation>? annotations,
    DartType? type,
  }) {
    return DartField(
      name: name ?? this.name,
      annotations: annotations ?? this.annotations,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return name;
  }
}
