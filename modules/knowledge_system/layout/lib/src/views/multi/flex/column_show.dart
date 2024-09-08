import 'package:flutter/material.dart';

class ColumnShow extends StatelessWidget {
  const ColumnShow({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      const Color(0xffe64032),
      const Color(0xff307dee),
      const Color(0xfff9c01f),
      const Color(0xff309949),
    ];
    return Column(
      children: [
        Container(width: 20, height: 20, color: colors[0]),
        Container(width: 10, height: 80, color: colors[1]),
        Container(width: 40, height: 30, color: colors[2]),
        Container(width: 60, height: 20, color: colors[3]),
      ],
    );
  }
}
