import 'package:flutter/material.dart';
import '/models/product.dart';

class ExpansionPage extends StatefulWidget {
  const ExpansionPage({Key? key}) : super(key: key);

  @override
  State<ExpansionPage> createState() => _ExpansionPageState();
}

class _ExpansionPageState extends State<ExpansionPage> {
  final List<Product> _products = Product.generateItems(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          const Text('Posto: '),
          DropdownButton<String>(
            dropdownColor: Theme.of(context).colorScheme.background,
            style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                decorationColor: Colors.black),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: "Eurípedes Barsanulfo (Morada Nova)",
                child: Text("Eurípedes Barsanulfo (Morada Nova)"),
              ),
            ],
            onChanged: (String? novoItemSelecionado) {
              if (novoItemSelecionado != null) {}
            },
            value: "Eurípedes Barsanulfo (Morada Nova)",
          ),
        ]),
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
