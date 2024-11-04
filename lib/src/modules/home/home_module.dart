import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:postos/src/modules/home/info_page.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'modelsview/insert_edit_view.dart';
import 'repositories/assistido_gsheet_repository.dart';
import 'youtube_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance<HomeController>(HomeController(
        assistidosStoreList:
            AssistidoRemoteStorageRepository(provider: Dio())));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const InfoPage());
    r.child('/home', child: (_) => const HomePage());  
    r.child('/youtube', child: (_) => const YoutubePage());                            
    r.child('/insert', child: (_) => InsertEditViewPage(assistido: r.args.data['assistido']));  
  }
}
