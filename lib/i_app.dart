import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'i_home.dart';

class IApp extends StatelessWidget {
  const IApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IHome(),
    );
  }
}
