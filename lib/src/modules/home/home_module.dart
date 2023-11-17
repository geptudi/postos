import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<HomeController>(HomeController.new); 
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
