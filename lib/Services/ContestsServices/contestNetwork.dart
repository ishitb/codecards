import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contestModel.dart';

class ContestAPI {
  String url = 'http://fb7b0a750ea4.ngrok.io/contestAPI';
  Future<List<ContestsAPIModel>> getContests(int page) async {
    final response = await http.get(Uri.parse("$url?page=$page"));
    List jsonData = json.decode(response.body)['results'];
    return jsonData.map((c) => ContestsAPIModel.fromJson(c)).toList();
  }
}
