import 'package:flutter/material.dart';
import '../../models/home_models.dart';

class HomeController {
  static const String tag = 'Assistidos';
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final ValueNotifier<String> activeTagButtom = ValueNotifier<String>(tag);
  final ValueNotifier<bool> state = ValueNotifier<bool>(false);
  final ValueNotifier<List<Map<String, dynamic>>> listaTelas =
      ValueNotifier<List<Map<String, dynamic>>>(mapTelas[tag]!);
  final PageController ctrl = PageController(viewportFraction: 0.85);

  int get currentPage => _currentPage.value;
  set currentPage(int value) => _currentPage.value = value;
}
