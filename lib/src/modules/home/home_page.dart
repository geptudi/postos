import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../models/product.dart';
import 'home_build_tag_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  final List<Product> _products = Product.generateItems(18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cestas Natalinas OSGETP')),
      drawer: HomeBuildTagPage(
        activeTagButtom: controller.activeTagButtom,
        listaTelas: controller.listaTelas,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ExpansionPanelList.radio(
            expansionCallback: (int index, bool isExpanded) {
              setState(() => _products[index].isExpanded = !isExpanded);
            },
            children: _products.map<ExpansionPanel>((Product product) {
              return ExpansionPanelRadio(
                // isExpanded: product.isExpanded,
                value: product.id,
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: CircleAvatar(child: Text(product.id.toString())),
                    title: Text(product.title),
                  );
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(product.description),
                    ),
                    Image.network(
                        'https://picsum.photos/id/${product.id}/500/300'),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}