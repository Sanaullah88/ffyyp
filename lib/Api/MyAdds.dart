import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fyp/model/feature/MyAdds.dart';

class AdsApi {
  Future<AllAds?> fetchads(String city) async {
    final Map<String, String> body = {'city': city};

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/getalladds"),
        body: body,
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final cjson = response.body;
        AllAds ads = AllAds.fromJson(json.decode(cjson));
        return ads;
      } else {
        // Handle other status codes if needed
        print("Failed to fetch ads. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Error: $e");
    }
  }
}
