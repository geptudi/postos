import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:postos/src/app_module.dart';
import 'package:postos/src/app_widget.dart';
import 'package:postos/src/models/parameters.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parameters.loadPostos();   // <--- CARREGA ANTES DE QUALQUER TELA
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}