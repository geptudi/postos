import 'package:flutter/material.dart';
import 'package:postos/src/modules/home/models/monta_alternativas.dart';
import 'package:postos/src/modules/home/modelsview/custom_button.dart';


class SingleSelectionList extends StatefulWidget {
  //final void Function(String)? answerFunc;
  final ValueNotifier<String> answer;
  final String? title;
  final IconData? icon;
  final List<String> options;
  final List<Color>? colors;
  final bool hasPrefiroNaoDizer;
  final int? optionsColumnsSize;
  final String? otherLabel;
  final Widget? otherItem;
  const SingleSelectionList({
    super.key,
    //this.answerFunc,
    this.title,
    this.icon,
    required this.options,
    required this.hasPrefiroNaoDizer,
    this.otherLabel,
    this.optionsColumnsSize,
    this.colors,
    this.otherItem,
    required this.answer,
  });

  @override
  State<SingleSelectionList> createState() => _SingleSelectionListState();
}

class _SingleSelectionListState extends State<SingleSelectionList> {
  final _formKey = GlobalKey<FormState>();
  static const double fontSize = 18;
  late ValueNotifier<String> answerAux;

  @override
  void initState() {
    super.initState();
    answerAux = ValueNotifier<String>(
        widget.options.contains(widget.answer.value) ||
                widget.answer.value == ""
            ? widget.answer.value
            : 'other');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        if (_formKey.currentState!.validate()) {
          widget.answer.value = answerAux.value;
        } else {
          widget.answer.value = '';
        }
        _formKey.currentState!.save();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null)
            Row(
              children: [
                if (widget.icon != null)
                  Icon(widget.icon!, color: Colors.black54),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    widget.title!,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                        decorationColor: Colors.black),
                  ),
                ),
              ],
            ),
          if (widget.title != null) const SizedBox(height: 15),
          FormField<ValueNotifier<String>>(
            initialValue: answerAux,
            autovalidateMode: AutovalidateMode.always, //.onUserInteraction,
            validator: (ValueNotifier<String>? value) {
              if (value == null) {
                return 'Por favor escolha um item';
              } else {
                if (value.value.isEmpty) {
                  return 'Por favor escolha um item';
                }
              }
              return (null);
            },
            builder: (FormFieldState<ValueNotifier<String>> state) =>
                MontaAlternativas(
              optionsColumnsSize: widget.optionsColumnsSize,
              length: widget.options.length,
              builder: (int id) => Expanded(
                child: CustomButton(
                  title: widget.options[id],
                  value: widget.options[id],
                  color: widget.colors?[id],
                  groupValue: answerAux,
                  onChanged: (_) {
                    state.didChange(answerAux);
                  },
                ),
              ),
              childList: <Widget>[
                if (widget.hasPrefiroNaoDizer)
                  Expanded(
                    child: CustomButton(
                        title: "Prefiro não dizer",
                        value: "Prefiro não dizer",
                        groupValue: answerAux,
                        onChanged: (_) {
                          state.didChange(answerAux);
                        }),
                  ),
                if (widget.otherItem != null)
                  Expanded(
                    child: CustomButton(
                      title: widget.otherLabel == null
                          ? "Outro (Qual?)"
                          : widget.otherLabel!,
                      value: "other",
                      groupValue: answerAux,
                      onChanged: (_) {
                        state.didChange(answerAux);
                      },
                    ),
                  ),
                if ((answerAux.value == "other") && (widget.otherItem != null))
                  Expanded(
                    child: widget.otherItem!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
