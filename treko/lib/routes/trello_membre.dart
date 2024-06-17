import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class MembreModel extends ChangeNotifier {
  final String apiKey = Config.apiKey;
  final String token = Config.token;
  final String baseUrl = 'https://api.trello.com/1';

  Future<List<dynamic>> searchMembers(String query) async {
    //print('the query is : $query');
    final response = await http.get(
      Uri.parse(
          '$baseUrl/search/members?key=$apiKey&token=$token&query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> membersData = jsonDecode(response.body);
      // print("the data member is : $membersData");

      return membersData;
    } else {
      print('Échec de la recherche des membres: ${response.statusCode}');

      return [];
    }
  }

  Future<List<dynamic>> boardMembers(String boardId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/boards/$boardId/members?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> membersData = jsonDecode(response.body);
      print("the board's member is : $membersData");

      List<dynamic> membersFullData = [];

      for (Map<String, dynamic> member in membersData) {
        final responseMember = await http.get(
          Uri.parse(
              '$baseUrl/members/${member["id"]}?key=$apiKey&token=$token'),
        );
        if (responseMember.statusCode == 200) {
          membersFullData.add(jsonDecode(responseMember.body));
        } else {
          print("failed to retrieve this member ${member}");
          print("the error code is : ${responseMember.statusCode}");
          print(
              "the responseMember.body of the error code is : ${responseMember.body}");
        }
      }
      print("the board's memberFulldata  is : $membersFullData");
      return membersFullData;
    } else {
      print('Échec de la recupération des membres: ${response.statusCode}');

      return [];
    }
  }
}
