import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:json_schema2/json_schema2.dart';

// normally I would load this from resource folder, but dart seems to not have
// that feature anymore since its switch aot compilation
// TODO: there could be a better way
const seed = """
{
  "pistes": [
    {
      "name": "Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)",
      "state": "closed",
      "notification": true
    },
    {
      "name": "Skitour Route Obertraun",
      "state": "closed",
      "notification": true
    }
  ]
}
""";

const schemaString = """
{
  "\$schema": "http://json-schema.org/draft-06/schema#",
  "\$ref": "#/definitions/Welcome",
  "definitions": {
    "Welcome": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "pistes": {
          "type": "array",
          "items": {
            "\$ref": "#/definitions/Piste"
          }
        }
      },
      "required": [
        "pistes"
      ],
      "title": "Welcome"
    },
    "Piste": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "name": {
          "type": "string"
        },
        "state": {
          "type": "string",
          "enum": ["open", "closed", "warning", "unknown"]
        },
        "notification": {
          "type": "boolean"
        }
      },
      "required": [
        "name",
        "notification",
        "state"
      ],
      "title": "Piste"
    }
  }
}
""";

void init() async{
  log("init db started");

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final persistenceDirectory = "${documentsDirectory.path}/.dachstein_pistes";
  log("persistenceDirectory = $persistenceDirectory");

  final directory = Directory(persistenceDirectory);
  if (directory.existsSync()) {
    log("persistenceDirectory existed already");
  } else {
    log("creating persistenceDirectory");
    directory.createSync(recursive: true);
  }
  final file = File(
      "$persistenceDirectory/"
      "persistence.json");
  if (file.existsSync()) {
    log("db already initialized");
  } else {
    log("initializing db");
    final jsonSchema = JsonSchema.createSchema(schemaString);
    if (jsonSchema.validate(seed, parseJson: true)) {
      file.writeAsStringSync(seed);
    } else {
      log("schema validation error!", level: 3);
      throw Exception("Dachstein Pistes could not start due to schema "
          "validation error");
    }
  }

  log("init db finished");
}
