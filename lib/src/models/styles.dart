import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const headerColor =  Color(0xFF9AB2DE);
final groundColor =  Colors.lightGreen.shade100; //Color(0xFFDDECF4); 
const borderSideValue =
    BorderSide(color: headerColor, width: 1.0, style: BorderStyle.solid);

abstract class Styles {
  static const TextStyle linhaProdutoNomeDoItem = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle linhaProdutoTotal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linhaProdutoPrecoDoItem = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 15,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle textoTempoEntrega = TextStyle(
    color: Color(0xFFC2C2C2),
    fontWeight: FontWeight.w300,
  );

  static const TextStyle tempoEntrega = TextStyle(
    color: CupertinoColors.inactiveGray,
  );

  static const Color linhaProdutoDivisor = Color(0xFFD9D9D9);

  static const Color fundoScaffold = Color(0xfff0f0f0);
}
