import 'package:test/test.dart';
import 'package:xml/xml.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartTypeFactory',
    () {
      group(
        'create',
        () {
          test(
            'should return a type with a name of bool for an XML text node with a value that is false',
            () {
              // Arrange
              final node = XmlText('false');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('bool'),
              );
            },
          );

          test(
            'should return a type with a name of bool for an XML text node with a value that is true',
            () {
              // Arrange
              final node = XmlText('true');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('bool'),
              );
            },
          );

          test(
            'should return a type with a name of DateTime for an XML text node with a value that is parsable as a DateTime',
            () {
              // Arrange
              final node = XmlText('1970-01-01');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('DateTime'),
              );
            },
          );

          test(
            'should return a type with a name of double for an XML text node with a value that is parsable as a double',
            () {
              // Arrange
              final node = XmlText('0.0');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('double'),
              );
            },
          );

          test(
            'should return a type with a name of int for an XML text node with a value that is parsable as an int',
            () {
              // Arrange
              final node = XmlText('0');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('int'),
              );
            },
          );

          test(
            'should return a type with a name of String for an XML text node with a value',
            () {
              // Arrange
              final node = XmlText('Hello World');

              // Act
              final type = const DartTypeFactory().create(node);

              // Assert
              expect(
                type.name,
                equals('String'),
              );
            },
          );
        },
      );
    },
  );
}
