import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '/models/product.dart';

class ExpansionPage extends StatefulWidget {
  const ExpansionPage({Key? key}) : super(key: key);

  @override
  State<ExpansionPage> createState() => _ExpansionPageState();
}

class _ExpansionPageState extends State<ExpansionPage> {
  final List<Product> _products = Product.generateItems(18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posto: '),
      ),
      floatingActionButton: customFloatingActionButton(context),
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

Widget customFloatingActionButton(BuildContext context) => SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Opções',
      heroTag: 'Seleciona Opções Diversas',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.collections),
          backgroundColor: Colors.red,
          label: 'Bezerra de Menezes (Pacaembu)',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {},
        ),
        SpeedDialChild(
            child: const Icon(Icons.add_box),
            backgroundColor: Colors.blue,
            label: 'Eurípedes Barsanulfo (Morada Nova)',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {}),
        SpeedDialChild(
            child: const Icon(Icons.assignment_returned),
            backgroundColor: Colors.green,
            label: 'Mãe Zeferina (Taiaman)',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {}),
        SpeedDialChild(
          child: const Icon(
            Icons.search,
          ),
          backgroundColor: Colors.yellow,
          label: 'Simão Pedro (São Francisco)',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {},
        ),
      ],
    );
