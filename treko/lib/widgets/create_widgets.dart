import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treko/routes/trello_board.dart';
import 'package:treko/widgets/colorpicker.dart';
import 'package:treko/widgets/template_picker.dart';

class CreateWidgets extends StatelessWidget {
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

  // Color hexToColor(String hexString) {
  //   hexString = hexString.replaceAll("#", "");
  //   hexString = "0xFF$hexString";
  //   int hexValue = int.parse(hexString);
  //   return Color(hexValue);
  // }

  const CreateWidgets({Key? key, required this.workspaceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newBoardName = '';
    String backgroundColor;
    String backgroundImage;

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Créer un nouveau tableau'),
              content: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    ColorPicker(
                      colors: colorList,
                      pic: picList,
                      onSelected: (item) {
                        if (item is Color) {
                          print("The item selected is a Color");
                          print(item);
                          String hexString =
                              "#" + item.value.toRadixString(16).substring(2);
                          print("The hexString is : $hexString ");
                          backgroundColor = hexString;
                          print("The backgroundColor is : $backgroundColor");
                        } else if (item is String) {
                          print("The item selected is an String so an url :");
                          print(item);
                          backgroundImage = item;
                          print("The backgroundImage is : $backgroundImage");
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value) {
                        newBoardName = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Nom du tableau',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TemplatePicker(
                      workspaceId: workspaceId,
                      contextOrigin: context,
                    ),
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
                        .createBoard(newBoardName, workspaceId)
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
}
