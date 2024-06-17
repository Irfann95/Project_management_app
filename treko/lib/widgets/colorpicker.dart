import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final List<Color> colors;
  // final ValueChanged<Color> onColorSelected;
  final List<String> pic;
  // final ValueChanged<String> onSelectedPic;
  final Function(dynamic) onSelected;

  const ColorPicker({
    Key? key,
    required this.pic,
    required this.colors,
    required this.onSelected,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  dynamic _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Choisir votre fond',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: widget.colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedItem = color;
                });
                widget.onSelected(color);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: _selectedItem == color
                    ? Icon(Icons.check, color: Colors.white, size: 15)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: widget.pic.map((pic) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedItem = pic;
                });
                widget.onSelected(pic);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(pic),
                      fit: BoxFit.cover,
                    )),
                child: _selectedItem == pic
                    ? Icon(Icons.check, color: Colors.black, size: 25)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
