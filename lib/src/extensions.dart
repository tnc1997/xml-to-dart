import 'dart:async';

import 'package:recase/recase.dart';
import 'package:xml/xml_events.dart';

import 'dart_class.dart';
import 'dart_field.dart';

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
                attribute.localName.camelCase,
                (field) {
                  return field.mergeWith(
                    DartField.fromXmlEventAttribute(
                      attribute,
                    ),
                  );
                },
                ifAbsent: () {
                  return DartField.fromXmlEventAttribute(
                    attribute,
                  );
                },
              );
            }

            classes.update(
              event.localName.pascalCase,
              (class_) {
                return class_.mergeWith(
                  DartClass.fromXmlStartElementEvent(
                    event,
                  ),
                );
              },
              ifAbsent: () {
                return DartClass.fromXmlStartElementEvent(
                  event,
                );
              },
            );

            classes[event.parent?.name.pascalCase]?.fields.update(
              event.localName.camelCase,
              (field) {
                return field.mergeWith(
                  DartField.fromXmlStartElementEvent(
                    event,
                  ),
                );
              },
              ifAbsent: () {
                return DartField.fromXmlStartElementEvent(
                  event,
                );
              },
            );
          } else if (event is XmlCDATAEvent) {
            if (event.value.trim().isNotEmpty) {
              classes[event.parent?.name.pascalCase]?.fields.update(
                'cdata',
                (field) {
                  return field.mergeWith(
                    DartField.fromXmlCDATAEvent(
                      event,
                    ),
                  );
                },
                ifAbsent: () {
                  return DartField.fromXmlCDATAEvent(
                    event,
                  );
                },
              );
            }
          } else if (event is XmlTextEvent) {
            if (event.value.trim().isNotEmpty) {
              classes[event.parent?.name.pascalCase]?.fields.update(
                'text',
                (field) {
                  return field.mergeWith(
                    DartField.fromXmlTextEvent(
                      event,
                    ),
                  );
                },
                ifAbsent: () {
                  return DartField.fromXmlTextEvent(
                    event,
                  );
                },
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
