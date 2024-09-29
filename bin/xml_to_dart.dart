import 'package:args/args.dart';

final parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Print this usage information.',
    negatable: false,
  )
  ..addOption(
    'input',
    abbr: 'i',
    help: 'The input file or directory.',
    mandatory: true,
  )
  ..addOption(
    'output',
    abbr: 'o',
    help: 'The output file or directory.',
    mandatory: false,
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
