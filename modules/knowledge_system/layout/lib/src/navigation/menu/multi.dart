import 'package:flutter/material.dart';

// import 'package:iroute/app/res/fx_icon.dart';
//     {
//       'path': '/expanded',
//       'label': '延展布局',
//       // 'icon': Icons.text_fields,
//     },
// {
// 'path': '/holy',
// 'label': '圣杯布局',
// // 'icon': Icons.text_fields,
// },
Map<String, dynamic> get multiMenus => {
      'path': '/multi',
      'icon': Icons.multitrack_audio,
      'label': '多子布局',
      'children': [
        {
          'path': '/flex',
          'label': 'Flex 适应布局',
        },
        {
          'path': '/wrap',
          'label': 'Wrap 包裹布局',
        },
        {
          'path': '/stack',
          'label': 'Stack 堆叠布局',
        },
      ]
    };
