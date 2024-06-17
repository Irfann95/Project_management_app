import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/pages/workspace.dart';
import 'package:treko/routes/trello_board.dart';
import 'package:treko/routes/trello_card.dart';
import 'package:treko/routes/trello_list.dart';
import 'package:treko/routes/trello_workspace.dart';
import 'package:treko/routes/trello_membre.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApiModel()),
        ChangeNotifierProvider(create: (context) => WorkspaceModel()),
        ChangeNotifierProvider(create: (context) => ListModel()),
        ChangeNotifierProvider(create: (context) => CardModel()),
        ChangeNotifierProvider(create: (context) => MembreModel()),
        ChangeNotifierProvider(create: (context) => CardUpdate()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treko',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: EspaceDeTravailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
