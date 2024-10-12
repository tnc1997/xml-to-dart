import 'package:test/test.dart';
import 'package:xml_to_dart/xml_to_dart.dart';

void main() {
  group(
    'DartType',
    () {
      group(
        'toString',
        () {
          test(
            'should return the string representation for a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'String',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('String'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('List<String>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('List<String?>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String, String>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String?, String>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String, String?>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of none and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.none,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String?, String?>'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'String',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('String?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('List<String>?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'List',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('List<String?>?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String, String>?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of none and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String?, String>?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of none and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.none,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String, String?>?'));
            },
          );

          test(
            'should return the string representation for a type with a name and a nullability suffix of question and a list of type arguments with a type with a name and a nullability suffix of question and an empty list of type arguments and a type with a name and a nullability suffix of question and an empty list of type arguments',
            () {
              // Arrange
              final type = DartType(
                name: 'Map',
                nullabilitySuffix: NullabilitySuffix.question,
                typeArguments: [
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                  DartType(
                    name: 'String',
                    nullabilitySuffix: NullabilitySuffix.question,
                    typeArguments: [],
                  ),
                ],
              );

              // Act
              final string = type.toString();

              // Assert
              expect(string, equals('Map<String?, String?>?'));
            },
          );
        },
      );
    },
  );
}
