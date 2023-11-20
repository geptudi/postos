import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MontaAlternativas extends StatelessWidget {
  final int? optionsColumnsSize;
  final int length;
  final Widget Function(int index) builder;
  final List<Widget>? childList;
  const MontaAlternativas({
    super.key,
    this.optionsColumnsSize,
    required this.length,
    required this.builder,
    this.childList,
  });
/*
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: optionsColumnsSize ?? 1,
      ),
      itemCount: length + (childList?.length ?? 0),
      itemBuilder: (BuildContext context, int index) =>
          index < length ? builder(index) : childList?[index - length],
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetListRow = List.generate(length, (index) => builder(index)) +
          (childList != null ? childList! : []);
    widgetListRow = widgetListRow
        .slices(optionsColumnsSize ?? 1)
        .map<Widget>(
          (e) => Row(children: e),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (widgetListRow),
    );
  }
}
