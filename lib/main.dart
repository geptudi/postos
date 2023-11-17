import 'package:flutter/material.dart';
import '/pages/expansion_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GEPT - Postos de Assistência',
      debugShowCheckedModeBanner: false,
      home: ExpansionPage(),
    );
  }
}
