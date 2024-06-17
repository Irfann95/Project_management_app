import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_card.dart';
// import 'package:treko/routes/trello_membre.dart';
import 'package:treko/widgets/card_assigned_widget.dart';

class CardDetail extends StatefulWidget {
  final Map<String, dynamic> card;
  final Widget child;

  const CardDetail({Key? key, required this.card, required this.child})
      : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController textFieldControllerCardName = TextEditingController();
  TextEditingController textFieldControllerCardDesc = TextEditingController();
  List<dynamic> membersCard = [];
  String originalCardName = "";
  String originalCardDesc = "";
  List<dynamic> originalMemberList = [];
  bool _isTextFieldFocused = false;
  bool _isDifferent = false;

  @override
  void initState() {
    super.initState();
    textFieldControllerCardName.text = widget.card["name"];
    textFieldControllerCardDesc.text = widget.card["desc"];
    membersCard = widget.card["idMembers"];
    originalCardName = widget.card["name"];
    originalCardDesc = widget.card["desc"];
    originalMemberList = widget.card["idMembers"];
    _focusNode.addListener(_onFocusChange);
    checkDifference();
  }

  @override
  void dispose() {
    // _focusNode.removeListener(_onFocusChange);
    // _focusNode.dispose();
    // textFieldControllerCardName.dispose();
    // textFieldControllerCardDesc.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isTextFieldFocused = _focusNode.hasFocus;
    });
  }

  void resetTextField() {
    setState(() {
      textFieldControllerCardName.text = originalCardName;
      textFieldControllerCardDesc.text = originalCardDesc;
      membersCard = originalMemberList;
      widget.card["name"] = originalCardName;
      widget.card["desc"] = originalCardDesc;
      widget.card["idMembers"] = originalMemberList;
      checkDifference();
    });
  }

  void checkDifference() {
    // print("the state of _isDifferent before  is : $_isDifferent");

    // print("int the checkDiff function : ");
    // print('the widget.card["name"] is : ${widget.card["name"]}');
    // print('the widget.card["desc"] is : ${widget.card["desc"]}');
    // print('the widget.card["idMembers"] is : ${widget.card["idMembers"]}');
    // print('the originalCardName is : $originalCardName');
    // print('the originalCardDesc is : $originalCardDesc');
    // print('the originalMemberList is : $originalMemberList');
    setState(() {
      if (widget.card["name"] != originalCardName ||
          widget.card["desc"] != originalCardDesc ||
          widget.card["idMembers"] != originalMemberList) {
        _isDifferent = true;
      } else {
        _isDifferent = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.credit_card_outlined),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: textFieldControllerCardName,
                      onChanged: (value) {
                        setState(() {
                          // print("In the Textfield of CardNAme");
                          // print(
                          //     'widget.card["name"]  value before change : ${widget.card["name"]}');
                          widget.card["name"] = value;
                          // print(
                          //     'widget.card["name"]  value after change : ${widget.card["name"]}');
                          checkDifference();
                        });
                      },
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _isTextFieldFocused ? Colors.white : null,
                        border: _isTextFieldFocused
                            ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              )
                            : InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text("Description"),
                      SizedBox(height: 2.0),
                      TextField(
                        controller: textFieldControllerCardDesc,
                        minLines: 3,
                        maxLines: null,
                        onChanged: (value) {
                          setState(() {
                            widget.card["desc"] = value;
                            checkDifference();
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter la description de votre carte ',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text("Assigner la carte"),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          ShowMembersDialog(
                              card: widget.card, context: context),
                          // if (membersCard.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (membersCard.isNotEmpty)
                                    FutureBuilder<List>(
                                      future: Provider.of<CardModel>(context,
                                              listen: false)
                                          .cardMembersAvatar(membersCard),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Erreur: ${snapshot.error}');
                                        } else {
                                          final List<dynamic> memberFullData =
                                              snapshot.data!;
                                          return Row(
                                            children:
                                                memberFullData.map((member) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      member["avatarUrl"]),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),

                          ElevatedButton(
                              onPressed: () {
                                Provider.of<CardModel>(context, listen: false)
                                    .cardMembersAvatar(membersCard);
                              },
                              child: Text("Test Api"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Annuler")),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CardModel>(context, listen: false).updateCard(
                        widget.card["id"],
                        widget.card["desc"],
                        widget.card["name"]);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("Update Card"),
                )
              ],
            );
          },
        ).then((value) => resetTextField());
      },
      child: widget.child,
    );
  }
}
