import 'package:args/args.dart';

final parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Print this usage information.',
  )
  ..addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Show additional command output.',
  );

void printUsage(ArgParser parser) {
  print('Usage: dart xml_to_dart.dart <flags> [arguments]');
  print(parser.usage);
}

void main(List<String> arguments) {
  try {
    final results = parser.parse(arguments);
    var verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(parser);
      return;
    }

    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(parser);
  }
}
