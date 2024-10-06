import 'dart:async';

import 'package:xml/xml_events.dart';

import 'dart_annotation.dart';
import 'dart_class.dart';
import 'dart_field.dart';
import 'dart_type.dart';
import 'namer.dart';

extension ToDartClassListExtension on Stream<List<XmlEvent>> {
  Future<List<DartClass>> toDartClassList() async {
    final classes = <String, DartClass>{};

    final completer = Completer<List<DartClass>>();

    final subscription = listen(
      (events) {
        for (final event in events) {
          if (event is XmlStartElementEvent) {
            final fields = <String, DartField>{};

            for (final attribute in event.attributes) {
              fields.update(
                camelCaseNamer(
                  attribute.localName,
                  attribute.namespaceUri,
                ),
                    (value) {
                  return value.copyWith(
                    type: value.type.mergeWith(
                      DartType.fromValue(
                        attribute.value,
                      ),
                    ),
                  );
                },
                ifAbsent: () {
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
                },
              );
            }

            classes.update(
              pascalCaseNamer(
                event.localName,
                event.namespaceUri,
              ),
                  (value) {
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
                  fields: fields,
                );
              },
              ifAbsent: () {
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
                  fields: fields,
                );
              },
            );

            final parent = event.parent;
            if (parent != null) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields[camelCaseNamer(
                event.localName,
                event.namespaceUri,
              )] = DartField(
                name: camelCaseNamer(
                  event.localName,
                  event.namespaceUri,
                ),
                annotations: [
                  XmlElementDartAnnotation.fromXmlStartElementEvent(
                    event,
                  ),
                ],
                type: DartType(
                  name: pascalCaseNamer(
                    event.localName,
                    event.namespaceUri,
                  ),
                  nullabilitySuffix: NullabilitySuffix.none,
                ),
              );
            }
          } else if (event is XmlCDATAEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields['cdata'] = DartField(
                name: 'cdata',
                annotations: [
                  const XmlCDATADartAnnotation(),
                ],
                type: DartType.fromValue(
                  event.value,
                ),
              );
            }
          } else if (event is XmlTextEvent) {
            final parent = event.parent;
            if (parent != null && event.value.isNotEmpty) {
              classes[pascalCaseNamer(
                parent.name,
                parent.namespaceUri,
              )]
                  ?.fields['text'] = DartField(
                name: 'text',
                annotations: [
                  const XmlTextDartAnnotation(),
                ],
                type: DartType.fromValue(
                  event.value,
                ),
              );
            }
          }
        }
      },
      onError: (error, stackTrace) {
        completer.completeError(error, stackTrace);
      },
      onDone: () {
        completer.complete([...classes.values]);
      },
      cancelOnError: true,
    );

    try {
      return await completer.future;
    } finally {
      await subscription.cancel();
    }
  }
}
