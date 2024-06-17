import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _selectedColor = Colors.transparent;

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          final color = _colors[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: _selectedColor == color
                        ? Colors.black
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
