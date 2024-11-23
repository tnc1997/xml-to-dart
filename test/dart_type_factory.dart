import 'package:test/test.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartTypeFactory',
    () {
      group(
        'create',
        () {
          test(
            'should return a type with a name of bool for a value that is false',
            () {
              // Arrange
              final value = 'false';

              // Act
              final type = const DartTypeFactory().create(value);

              // Assert
              expect(
                type.name,
                equals('bool'),
              );
            },
          );

          test(
            'should return a type with a name of bool for a value that is true',
            () {
              // Arrange
              final value = 'true';

              // Act
              final type = const DartTypeFactory().create(value);

              // Assert
              expect(
                type.name,
                equals('bool'),
              );
            },
          );

          test(
            'should return a type with a name of DateTime for a value that is parsable as a DateTime',
            () {
              // Arrange
              final value = '1970-01-01';

              // Act
              final type = const DartTypeFactory().create(value);

              // Assert
              expect(
                type.name,
                equals('DateTime'),
              );
            },
          );

          test(
            'should return a type with a name of double for a value that is parsable as a double',
            () {
              // Arrange
              final value = '0.0';

              // Act
              final type = const DartTypeFactory().create(value);

              // Assert
              expect(
                type.name,
                equals('double'),
              );
            },
          );

          test(
            'should return a type with a name of int for a value that is parsable as an int',
            () {
              // Arrange
              final value = '0';

              // Act
              final type = const DartTypeFactory().create(value);

              // Assert
              expect(
                type.name,
                equals('int'),
              );
            },
          );

          test(
            'should return a type with a name of String for a value',
            () {
              // Arrange
              final value = 'Hello World';

              // Act
              final type = const DartTypeFactory().create(value);

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
