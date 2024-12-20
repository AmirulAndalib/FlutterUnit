import 'package:flutter/material.dart';

/// create by 张风捷特烈 on 2020-03-28
/// contact me by email 1981462002@qq.com

class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key});

  List<Color> get data => [
    Colors.green[50]!,
    Colors.green[100]!,
    Colors.green[200]!,
    Colors.green[300]!,
    Colors.green[400]!,
    Colors.green[500]!,
    Colors.green[600]!,
    Colors.green[700]!,
    Colors.green[800]!,
    Colors.green[900]!,
  ];

  TextStyle get textStyle =>
      const TextStyle(color: Colors.white, fontSize: 24, shadows: [
        Shadow(
          color: Colors.black,
          offset: Offset(.5, .5),
          blurRadius: 2,
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        onPageChanged: (position) => print(position),
        children: data
            .map((color) => Container(
                  alignment: Alignment.center,
                  width: 90,
                  color: color,
                  child: Text(
                    colorString(color),
                    style: textStyle,
                  ),
                ))
            .toList(),
      ),
    );
  }

  String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
}
