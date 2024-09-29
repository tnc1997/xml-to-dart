import 'package:args/args.dart';

final parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Print this usage information.',
  );

void main(
  List<String> arguments,
) {
  final ArgResults results;

  try {
    results = parser.parse(arguments);
  } catch (e) {
    print(e);
    return;
  }

  if (results.wasParsed('help')) {
    print('Usage: dart xml_to_dart.dart <flags> [arguments]');
    print(parser.usage);
    return;
  }
}
