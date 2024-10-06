import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'namer.dart';

class DartClass {
  final String name;
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.name,
    required this.annotations,
    required this.fields,
  });

  factory DartClass.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return DartClass(
      name: pascalCaseNamer(
        event.localName,
        event.namespaceUri,
      ),
      annotations: [
        XmlRootElementDartAnnotation.fromXmlStartElementEvent(
          event,
        ),
        const XmlSerializableDartAnnotation(),
      ],
      fields: {
        for (final attribute in event.attributes)
          camelCaseNamer(
            attribute.localName,
            attribute.namespaceUri,
          ): DartField.fromXmlEventAttribute(
            attribute,
          ),
      },
    );
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is DartClass && name == other.name;
  }

  @override
  String toString() {
    return name;
  }
}
