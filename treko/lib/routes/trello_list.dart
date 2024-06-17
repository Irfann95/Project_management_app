import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class ListModel extends ChangeNotifier {
  final String apiKey = Config.apiKey;
  final String token = Config.token;
  final String baseUrl = 'https://api.trello.com/1';

  Future<List<dynamic>> fetchList(String boardId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.trello.com/1/boards/$boardId/lists?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> listsData = jsonDecode(response.body);
      // print("The id of the board is : ");
      // print(boardId);
      // print("The lists data is : ");
      // print(listsData);
      return listsData;
    } else {
      print('Échec de la récupération des lists: ${response.statusCode}');
      return [];
    }
  }

  Future<void> createList(String name, String boardId) async {
    final Map<String, String> body = {
      'name': name,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/boards/$boardId/lists?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Liste créée avec succès');
      print(response.body);
    } else {
      print('Échec de la création de la liste: ${response.statusCode}');
      print(body);
    }
    notifyListeners();
  }

  Future<void> deleteList(String listId) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/lists/$listId/closed?value=true&key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      print('Liste supprimée avec succès');
      print(response.body);
    } else {
      print('Échec de la supretion de la liste: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> editList(String newName, String listId) async {
    final Map<String, String> body = {
      'name': newName,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/lists/$listId?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Liste modifiée avec succès');
      print(response.body);
    } else {
      print('Échec de la modification de la liste: ${response.statusCode}');
      print(body);
    }
    notifyListeners();
  }
}
