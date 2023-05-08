import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:studio_yaiverse_mobile/models/3d_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev/";
  static const String today = "today";

  static Future<List<ThreeDModel>> getThreeDModels() async {
    List<ThreeDModel> threedInstances = [];
    final url = Uri.parse('$baseUrl$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> threedmodels = jsonDecode(response.body);
      for (var threedmodel in threedmodels) {
        threedInstances.add(ThreeDModel.fromJson(threedmodel));
      }
      return threedInstances;
    }
    throw Error;
  }

  static const String Url = "http://studio-yaiverse.kro.kr";

  static Future<List<GetThreeDList>> getThreeDList(username) async {
    List<GetThreeDList> threedInstances = [];
    final url = Uri.parse('$Url/main/list/$username');
    final response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> threedmodels = jsonDecode(response.body);
      for (var threedmodel in threedmodels) {
        threedInstances.add(GetThreeDList.fromJson(threedmodel));
      }
      return threedInstances;
    }
    return threedInstances;
  }

  void registerAccount(String userId) async {
    final url = Uri.parse('$Url/accounts/register/');
    var value = {"username": userId};
    var data = json.encode(value);
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    print(res);
  }

  //static Future<String>
  static Future<String> GenThreeDbyText(
      String username, String text, String name) async {
    final url = Uri.parse('$Url/main/create/$username/');
    var data = {
      "name": name,
      "description": username,
      "text": text,
      "thumbnail_uri": ""
    };
    var body = json.encode(data);
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      return Gen3D.fromJson(jsonDecode(res.body)).thumbnail_uri;
    } catch (e) {
      throw Error;
    }
  }
}
