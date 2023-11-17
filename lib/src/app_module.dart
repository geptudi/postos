import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/home_module.dart';


class AppModule extends Module {
  @override
  void routes(r) {
    r.module('/', module: HomeModule());   
    r.module('/postos/', module: HomeModule());       
  }
}
