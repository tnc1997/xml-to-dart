import 'package:recase/recase.dart';

typedef Namer = String Function(
  String name, [
  String? namespace,
]);

String camelCaseNamer(
  String name, [
  String? namespace,
]) {
  return name.camelCase;
}

String pascalCaseNamer(
  String name, [
  String? namespace,
]) {
  return name.pascalCase;
}

String snakeCaseNamer(
  String name, [
  String? namespace,
]) {
  return name.snakeCase;
}
