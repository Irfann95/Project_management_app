import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class CardModel extends ChangeNotifier {
  final String apiKey = Config.apiKey;
  final String token = Config.token;
  final String baseUrl = 'https://api.trello.com/1';

  Future<List<dynamic>> fetchCards(String listId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/lists/$listId/cards?key=$apiKey&token=$token',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> cardsData = jsonDecode(response.body);
      // print("The data of the fetchCards is : \n $cardsData");
      return cardsData;
    } else {
      print(
          'Échec de la récupération des espaces de travail: ${response.statusCode}');
      return [];
    }
  }

  Future<void> createCard(
      String name, String cardDescription, String listId) async {
    final Map<String, String> body = {
      'name': name,
      'idList': listId,
      'desc': cardDescription
    };

    final response = await http.post(
      Uri.parse('$baseUrl/cards?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final cardId = responseData['id'];
      print('Carte créée avec succès avec l\'ID : $cardId');
    } else {
      print('Échec de la création de la carte: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> assignMemberToCard(String cardId, String memberId) async {
    final Map<String, String> body = {
      'value': memberId,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/cards/$cardId/idMembers?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('Assignation réussie de la personne à la carte');
    } else {
      print(
          'Échec de l\'assignation de la personne à la carte: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> deleteCard(String cardId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cards/$cardId?key=$apiKey&token=$token'),
    );

    if (response.statusCode == 200) {
      print('La carte $cardId a été définitivement supprimer');
    } else {
      print(
          'Échec de l\'assignation de la personne à la carte: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<void> updateCard(String cardId, String desc, String name) async {
    final Map<String, String> body = {
      'name': name,
      'desc': desc,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/cards/$cardId?key=$apiKey&token=$token'),
      body: body,
    );

    if (response.statusCode == 200) {
      print('La carte $cardId a été update');
    } else {
      print('Échec de l\'update de la carte: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<List<dynamic>> cardMembersData(List<String> membersId) async {
    List<dynamic> membersFullData = [];

    for (String memberId in membersId) {
      final response = await http.get(
        Uri.parse('$baseUrl/members/$memberId?key=$apiKey&token=$token'),
      );
      if (response.statusCode == 200) {
        membersFullData.add(jsonDecode(response.body));
        print(membersFullData);
      } else {
        print("failed to retrieve this member $memberId");
        print("the error code is : ${response.statusCode}");
        print("the response.body of the error code is : ${response.body}");
      }
    }
    print("the board's memberFulldata  is : $membersFullData");
    notifyListeners();
    return membersFullData;
  }

  Future<List<dynamic>> cardMembersAvatar(List<dynamic> membersId) async {
    List<dynamic> membersAvatar = [];
    print("the membersId is : $membersId");

    for (dynamic memberId in membersId) {
      final response = await http.get(
        Uri.parse('$baseUrl/members/$memberId?key=$apiKey&token=$token'),
      );

      if (response.statusCode == 200) {
        membersAvatar.add(jsonDecode(response.body));
        print(membersAvatar);
      } else {
        print("failed to retrieve this member $memberId");
        print("the error code is : ${response.statusCode}");
        print("the response.body of the error code is : ${response.body}");
      }
    }
    print("the board's memberFulldata  is : $membersAvatar");
    notifyListeners();
    return membersAvatar;
  }
}

class CardUpdate extends ChangeNotifier {
  bool _isDifferent = false;

  bool get isDifferent => _isDifferent;

  void setIsDifferent(bool isDifferent) {
    _isDifferent = isDifferent;
    notifyListeners();
  }

  Widget updateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isDifferent
          ? () {
              print("Update card");
            }
          : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          _isDifferent ? Colors.green : Colors.grey,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text("Update Card"),
    );
  }
}
