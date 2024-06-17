import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class ApiModel extends ChangeNotifier {
  final String apiKey = Config.apiKey;
  final String token = Config.token;
  final String baseUrl = 'https://api.trello.com/1';
  final String templateUrl =
      'https://trello.com/1/batch?urls=%2F1%2Fboard%2F5c4efa1d25a9692173830e7f%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5ec98d97f98409568dd89dff%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5994bf29195fa87fb9f27709%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5e6005043fbdb55d9781821e%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5b78b8c106c63923ffe26520%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5aaafd432693e874ec11495c%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F591ca6422428d5f5b2794aee%3Ffields%3Did%252Cname%252Cprefs,%2F1%2Fboard%2F5994be8ce20c9b37589141c2%3Ffields%3Did%252Cname%252Cprefs';

  Future<List<dynamic>> fetchBoards(String workspaceId) async {
    print('The workspace Id is :');
    print(workspaceId);
    final response = await http.get(
      Uri.parse(
          '$baseUrl/organizations/$workspaceId/boards?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> boardsData = jsonDecode(response.body);
      return boardsData;
    } else {
      print('Échec de la récupération des tableaux: ${response.statusCode}');
      return [];
    }
  }

  Future<void> createBoard(String name, String workspaceId) async {
    final Map<String, String> body = {
      'name': name,
      'idOrganization': workspaceId
    };

    final response = await http.post(
      Uri.parse('$baseUrl/boards?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final boardId = responseData['id'];
      print('Tableau créé avec succès avec l\'ID : $boardId');
    } else {
      //erreurs
      print('Échec de la création du tableau: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> createBoardWithTemplate(String name, String workspaceId,
      String templateID, bool keepCards) async {
    final Map<String, String> body = {
      'name': name,
      'idOrganization': workspaceId,
      'idBoardSource': templateID,
      'keepFromSource': keepCards ? "cards" : "none"
    };

    final response = await http.post(
      Uri.parse('$baseUrl/boards?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final boardId = responseData['id'];
      print('Tableau créé avec succès avec l\'ID : $boardId');
    } else {
      //erreurs
      print('Échec de la création du tableau: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> deleteBoard(String boardId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/boards/$boardId?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      print('Tableau supprimé avec succès');
    } else {
      print('Échec de la suppression du tableau: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> editBoard(String boardId, String newName) async {
    final Map<String, String> body = {
      'name': newName,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/boards/$boardId?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Tableau renommé avec succès');
    } else {
      print('Échec du renommage du tableau: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> inviteToBoard(String boardId, String email) async {
    final Map<String, String> body = {
      'email': email,
      'type': 'normal',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/boards/$boardId/members?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Invitation envoyé à $email');
    } else {
      print('Échec de l\'envoi de l\'invitation: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> addToBoard(String boardId, String email, String userId) async {
    final Map<String, String> body = {
      'email': email,
      'type': 'normal',
      'userId': userId,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/boards/$boardId/members?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Ajout de $email réussi');
    } else {
      print('Échec de l\'ajout de l\'utilisateur: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> removeFromBoard(
      String boardId, String email, String userId) async {
    final Map<String, String> body = {
      'email': email,
      'type': 'normal',
      'userId': userId,
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/boards/$boardId/members?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Retrait de $email réussi');
    } else {
      print('Échec du retrait de l\'utilisateur: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<List<dynamic>> fetchBoardTemplate() async {
    final response = await http.get(Uri.parse(templateUrl));
    if (response.statusCode == 200) {
      final List<dynamic> boardsData = jsonDecode(response.body);

      List<dynamic> templateData = [];

      for (var element in boardsData) {
        if (element.containsKey("200")) {
          templateData.add(element["200"]);
        }
      }

      print("The templateData is :");
      print(templateData);
      return templateData;
    } else {
      print('Échec de la récupération des templates: ${response.statusCode}');
      return [];
    }
  }
}
