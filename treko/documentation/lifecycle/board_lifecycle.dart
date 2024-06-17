import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_board.dart';
import 'package:treko/widgets/colorpicker.dart';
import 'package:treko/widgets/template_picker.dart';

class CreateBoardWidgets extends StatefulWidget {
  final String workspaceId;
  final List<Color> colorList = const [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple
  ];
  final List<String> picList = const [
    "https://res.cloudinary.com/drpikzud7/image/upload/v1710788348/wcpqgnexxs4lcxdib9of.png",
    "https://res.cloudinary.com/drpikzud7/image/upload/v1710788302/iqrglektpiboxkjmpcgc.png"
  ];

  const CreateBoardWidgets({Key? key, required this.workspaceId}) : super(key: key);

  @override
  _CreateWidgetsState createState() => _CreateWidgetsState();
}

class _CreateWidgetsState extends State<CreateBoardWidgets> {
  String newBoardName = '';
  String backgroundColor = '';
  String backgroundImage = '';

  @override
  void initState() {
    super.initState();
    // Initialisation des variables si nécessaire
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Créer un nouveau tableau'),
              content: Container(
                height: 300, // Specifying the height of the container
                child: Column(
                  children: <Widget>[
                    ColorPicker(
                      colors: widget.colorList,
                      pic: widget.picList,
                      onSelected: (item) {
                        if (item is Color) {
                          setState(() {
                            String hexString =
                                "#" + item.value.toRadixString(16).substring(2);
                            backgroundColor = hexString;
                          });
                        } else if (item is String) {
                          setState(() {
                            backgroundImage = item;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newBoardName = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nom du tableau',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TemplatePicker(workspaceId: widget.workspaceId)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<ApiModel>(context, listen: false)
                        .createBoard(newBoardName, widget.workspaceId)
                        .then((value) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print('Erreur lors de la création du tableau: $error');
                    });
                  },
                  child: Text('Créer'),
                ),
              ],
            );
          },
        );
      },
      child: Text('+ Créer un nouveau tableau'),
    );
  }

  @override
  void dispose() {
    // Libération des ressources si nécessaire
    super.dispose();
  }
}

