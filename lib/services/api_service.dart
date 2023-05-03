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

  static const String Url = "https://webtoon-crawler.nomadcoders.workers.dev/";

  static Future<List<GetThreeDList>> getThreeDList(username) async {
    List<GetThreeDList> threedInstances = [];
    final url = Uri.parse('$baseUrl/main/list/$username');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> threedmodels = jsonDecode(response.body);
      for (var threedmodel in threedmodels) {
        threedInstances.add(GetThreeDList.fromJson(threedmodel));
      }
      return threedInstances;
    }
    throw Error;
  }

  void registerAccount(String userId) async {
    final url = Uri.parse('$Url/accounts/register/');
    try {
      http.post(url,
          headers: {"Content-Type": "application/json"},
          body: {"username": userId});
    } catch (e) {
      print(e);
    }
  }
}
