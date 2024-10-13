import 'package:recase/recase.dart';
import 'package:xml/xml.dart';

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
      final other = DartField.fromXmlAttribute(attribute);

      fields.update(
        attribute.localName.camelCase,
        (value) {
          if (value.type.name == 'List' && other.type.name == 'List') {
            return DartField(
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeMerger().merge(
                    value.type.typeArguments.single,
                    other.type.typeArguments.single,
                  ),
                ],
              ),
            );
          } else if (value.type.name == 'List') {
            return DartField(
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeMerger().merge(
                    value.type.typeArguments.single,
                    other.type,
                  ),
                ],
              ),
            );
          } else if (other.type.name == 'List') {
            return DartField(
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeMerger().merge(
                    value.type,
                    other.type.typeArguments.single,
                  ),
                ],
              ),
            );
          } else {
            return DartField(
              annotations: value.annotations.toList(),
              type: DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  const DartTypeMerger().merge(
                    value.type,
                    other.type,
                  ),
                ],
              ),
            );
          }
        },
        ifAbsent: () {
          return other;
        },
      );
    }

    final cdata = StringBuffer();
    final text = StringBuffer();

    for (final child in element.children) {
      if (child is XmlElement) {
        final other = DartField.fromXmlElement(child);

        fields.update(
          child.localName.camelCase,
          (value) {
            if (value.type.name == 'List' && other.type.name == 'List') {
              return DartField(
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeMerger().merge(
                      value.type.typeArguments.single,
                      other.type.typeArguments.single,
                    ),
                  ],
                ),
              );
            } else if (value.type.name == 'List') {
              return DartField(
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeMerger().merge(
                      value.type.typeArguments.single,
                      other.type,
                    ),
                  ],
                ),
              );
            } else if (other.type.name == 'List') {
              return DartField(
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeMerger().merge(
                      value.type,
                      other.type.typeArguments.single,
                    ),
                  ],
                ),
              );
            } else {
              return DartField(
                annotations: value.annotations.toList(),
                type: DartType(
                  name: 'List',
                  nullabilitySuffix: NullabilitySuffix.none,
                  typeArguments: [
                    const DartTypeMerger().merge(
                      value.type,
                      other.type,
                    ),
                  ],
                ),
              );
            }
          },
          ifAbsent: () {
            return other;
          },
        );
      } else if (child is XmlCDATA) {
        cdata.write(child.value.trim());
      } else if (child is XmlText) {
        text.write(child.value.trim());
      }
    }

    if (cdata.isNotEmpty) {
      fields['cdata'] = DartField.fromXmlCDATA(XmlCDATA('$cdata'));
    }

    if (text.isNotEmpty) {
      fields['text'] = DartField.fromXmlText(XmlText('$text'));
    }

    return DartClass(
      annotations: [
        XmlRootElementDartAnnotation.fromXmlElement(element),
        const XmlSerializableDartAnnotation(),
      ],
      fields: fields,
    );
  }
}

class DartClassMerger {
  final DartFieldMerger _dartFieldMerger;

  const DartClassMerger({
    DartFieldMerger dartFieldMerger = const DartFieldMerger(),
  }) : _dartFieldMerger = dartFieldMerger;

  DartClass merge(
    DartClass a,
    DartClass b,
  ) {
    final fields = <String, DartField>{};
    for (final entry in a.fields.entries) {
      final other = b.fields[entry.key];
      if (other != null) {
        fields[entry.key] = _dartFieldMerger.merge(entry.value, other);
      } else {
        fields[entry.key] = entry.value;
      }
    }

    return DartClass(
      annotations: a.annotations.toList(),
      fields: fields,
    );
  }
}
