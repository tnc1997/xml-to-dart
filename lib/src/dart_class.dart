import 'package:recase/recase.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_field.dart';
import 'dart_type.dart';

class DartClass {
  final List<DartAnnotation> annotations;
  final Map<String, DartField> fields;

  const DartClass({
    required this.annotations,
    required this.fields,
  });

  factory DartClass.fromXmlElement(
    XmlElement element,
  ) {
    final fields = <String, DartField>{};

    for (final attribute in element.attributes) {
      fields[attribute.localName.camelCase] =
          XmlAttributeDartField.fromXmlAttribute(attribute);
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in element.children) {
      if (child is XmlElement) {
        fields[child.localName.camelCase] =
            XmlElementDartField.fromXmlElement(child);
      } else if (child is XmlCDATA) {
        cdata.write(child.value.trim());
      } else if (child is XmlText) {
        text.write(child.value.trim());
      }
    }

    if (cdata.isNotEmpty) {
      fields['cdata'] =
          XmlCDATADartField.fromXmlCDATA(XmlCDATA(cdata.toString()));
    }

    if (text.isNotEmpty) {
      fields['text'] = XmlTextDartField.fromXmlText(XmlText(text.toString()));
    }

    return DartClass(
      annotations: [
        XmlRootElementDartAnnotation.fromXmlElement(element),
        const XmlSerializableDartAnnotation(),
      ],
      fields: fields,
    );
  }

  factory DartClass.fromXmlStartElementEvent(
    XmlStartElementEvent event,
  ) {
    return DartClass(
      annotations: [
        XmlRootElementDartAnnotation.fromXmlStartElementEvent(
          event,
        ),
        const XmlSerializableDartAnnotation(),
      ],
      fields: {
        for (final attribute in event.attributes)
          attribute.localName.camelCase: XmlAttributeDartField(
            type: DartType.fromValue(
              attribute.value.trim(),
            ),
            name: attribute.localName,
            namespace: attribute.namespaceUri,
          ),
      },
    );
  }
}

class DartClassMerger {
  const DartClassMerger();

  DartClass merge(
    DartClass a,
    DartClass b,
  ) {
    final fields = <String, DartField>{};
    for (final entry in a.fields.entries) {
      final other = b.fields[entry.key];
      if (other != null) {
        fields[entry.key] = entry.value
          ..type = const DartTypeMerger().merge(
            entry.value.type,
            other.type,
          );
      } else {
        fields[entry.key] = entry.value;
      }
    }

    return DartClass(
      annotations: [...a.annotations],
      fields: fields,
    );
  }
}
