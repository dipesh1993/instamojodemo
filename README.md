# instamojodemo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

import 'dart:convert';

void main() {
  String jsonResponse = '''
  {
    "status": true,
    "message": "Lookup Get List",
    "data": {
      "LookupData": {
        "BC location type": "[{\\"LookupID\\":2688,\\"LookupCategory\\":\\"S\\",\\"LookupType\\":\\"BC location type\\",\\"LookupCode\\":\\"New Location\\",\\"LookupName\\":\\"New Location\\"},{\\"LookupID\\":2689,\\"LookupCategory\\":\\"S\\",\\"LookupType\\":\\"BC location type\\",\\"LookupCode\\":\\"Replacement of BC location\\",\\"LookupName\\":\\"Replacement of BC location\\"}]",
        "CVV_VisitType": "[{\\"LookupID\\":2684,\\"LookupCategory\\":\\"S\\",\\"LookupType\\":\\"CVV VisitType\\",\\"LookupCode\\":\\"Customer visit\\",\\"LookupName\\":\\"Customer Visit\\"},{\\"LookupID\\":2686,\\"LookupCategory\\":\\"S\\",\\"LookupType\\":\\"CVV VisitType\\",\\"LookupCode\\":\\"BC Visit\\",\\"LookupName\\":\\"BC Visit\\"}]"
      }
    }
  }
  ''';

  // Function to recursively deserialize nested serialized JSON strings
  dynamic deserializeJson(dynamic json) {
    if (json is String) {
      try {
        // Try parsing the string as JSON
        return deserializeJson(jsonDecode(json));
      } catch (e) {
        // Return the original string if parsing fails
        return json;
      }
    } else if (json is List) {
      // If it's a list, recursively process each element
      return json.map(deserializeJson).toList();
    } else if (json is Map) {
      // If it's a map, recursively process each value
      return json.map((key, value) => MapEntry(key, deserializeJson(value)));
    }
    return json; // Return the original value if it's not a String, List, or Map
  }

  // Parse the initial JSON
  Map<String, dynamic> parsedJson = jsonDecode(jsonResponse);

  // Recursively deserialize the nested JSON
  dynamic fullyDeserializedJson = deserializeJson(parsedJson);

  print(fullyDeserializedJson);
}

