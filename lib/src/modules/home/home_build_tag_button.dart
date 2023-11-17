import 'package:flutter/material.dart';

class BuildTagButton extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> listaTelas;
  final ValueNotifier<String> activeTagButtom;
  final List<String> tag;
  final Icon icon;
  const BuildTagButton(
      {Key? key,
      required this.activeTagButtom,
      required this.tag,
      required this.icon,
      required this.listaTelas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color =
        tag[0] == activeTagButtom.value ? Colors.purple : Colors.black26;
    return SizedBox(
        width: 300,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: color,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              Container(
                margin: const EdgeInsets.only(
                  left: 10.0,
                  top: 0.0,
                  bottom: 0.0,
                  right: 00.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tag.map((e) => Text(e)).toList(),
                ),
              ),
            ],
          ),
          onPressed: () {
            activeTagButtom.value = tag[0];
          },
        ));
  }
}
