import 'dart:core';
import 'package:flutter/material.dart';
import '../../../models/styles.dart';



class CustomButton extends StatelessWidget {
  final String title;
  final Color? color;
  final String value;
  final ValueNotifier<String> groupValue;
  final Function(String?)? onChanged;

  const CustomButton({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
          valueListenable: groupValue,
          builder: (context, groupValueNotifier, _) => Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: value == groupValueNotifier
                ? WidgetStateProperty.all<Color>(color ??headerColor/* Colors.black54*/)
                : WidgetStateProperty.all<Color>(Colors.white),
            elevation: WidgetStateProperty.all(8),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(width: 0.2, color: color ?? headerColor/*Colors.black54*/),
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: value == groupValueNotifier ? Colors.white : Colors.black87,
            ),
          ),
          onPressed: () {
            if(groupValue.value == value) {
              groupValue.value = "";
            } else {
              groupValue.value = value;
            }
            if(onChanged != null) onChanged!(groupValue.value);
          },
        ),
      ),);
}
