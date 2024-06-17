import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class WorkspaceModel extends ChangeNotifier {
  final String apiKey = Config.apiKey;
  final String token = Config.token;
  final String baseUrl = 'https://api.trello.com/1';

  Future<List<dynamic>> fetchWorkspaces() async {
    final response = await http.get(
      Uri.parse(
        'https://api.trello.com/1/members/me/organizations?key=$apiKey&token=$token',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> workspaceData = jsonDecode(response.body);

      return workspaceData;
    } else {
      print(
          'Échec de la récupération des espaces de travail: ${response.statusCode}');
      return [];
    }
  }

  Future<void> createWorkspace(String name) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/organizations?displayName=$name&key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final workspaceId = responseData['id'];
      print('Tableau créé avec succès avec l\'ID : $workspaceId');
    } else {
      print('Échec de la création du tableau: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> editWorkspace(String workspaceId, String newName) async {
    final Map<String, String> body = {
      'displayName': newName,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/organizations/$workspaceId?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Espace de travail renommé avec succès');
    } else {
      print(
          'Échec du renommage de l\'espace de travail: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> deleteWorkspace(String workspaceId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/organizations/$workspaceId?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      print('Espace de travail supprimé avec succès');
    } else {
      print(
          'Échec de la suppression de l\'espace de travail: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<String> inviteToWorkspace(String workspaceId, String email) async {
    final Map<String, String> body = {
      'email': email,
    };

    final response = await http.put(
      Uri.parse(
          '$baseUrl/organizations/$workspaceId/members?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Invitation envoyée à $email');
      notifyListeners();
      return "Invitation envoyée à $email";
    } else if (response.body == "Member already invited") {
      print("The response.body is : ${response.body}");
      notifyListeners();
      return "$email à déjà été invité";
    } else {
      print('Échec de l\'envoi de l\'invitation: ${response.statusCode}');
      print("the response is : ${response.body}");
      notifyListeners();
      return "Echec de l'envoie de l'invitation à $email";
    }
  }
}
