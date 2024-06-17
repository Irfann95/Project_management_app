import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_membre.dart';
import 'package:treko/routes/trello_workspace.dart';

class InviterMembreWidget extends StatefulWidget {
  final String workspaceId;

  const InviterMembreWidget({Key? key, required this.workspaceId})
      : super(key: key);

  @override
  _InviterMembreWidgetState createState() => _InviterMembreWidgetState();
}

class _InviterMembreWidgetState extends State<InviterMembreWidget> {
  TextEditingController _searchController = TextEditingController();
  String email = "";
  List<dynamic> _searchResults = [];

  void _searchMembers(String query) async {
    setState(() {
      email = query;
      print("the email is : $email");
    });

    final members = await Provider.of<MembreModel>(context, listen: false)
        .searchMembers(query);

    setState(() {
      _searchResults = members;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inviter un membre'),
        backgroundColor: Color(0xFF89CFF0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchMembers(value);
              },
              decoration: InputDecoration(
                labelText: 'Rechercher un membre par nom ou e-mail',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20.0),
            _searchResults.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final workspaceId = widget.workspaceId;
                        String responseInvite =
                            await Provider.of<WorkspaceModel>(context,
                                    listen: false)
                                .inviteToWorkspace(workspaceId, email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(responseInvite),
                          ),
                        );
                      },
                      child: Text('Ajouter'),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
