import 'package:flutter/material.dart';

class RadioListSP extends FormField<int> {
final List<String>? rlistui;

  RadioListSP  ({
    Key? key,
    FormFieldSetter<int>? onSaved,
    FormFieldValidator<int>? validator,
    int? initialValue,
    bool autovalidate = false,
    this.rlistui
  }):super(
  onSaved: onSaved,
  validator: validator,
  initialValue: initialValue,
  autovalidateMode: AutovalidateMode.always,
  builder:(FormFieldState<int> state) {
   // int grvalue=0;

    List<Widget>   rl(FormFieldState<int> state) {
      List<RadioListTile<int>> container;
      container = List <RadioListTile<int>>.generate(
      rlistui!.length,
      (int index){

      return new RadioListTile<int>(
      title:  Text(rlistui[index]/*index.toString()*/),
      value:index,
      groupValue:  state.value,
      onChanged: (int? value) { state.didChange!(value);},
      );          }

      );
      return container;
    }

    return new
    SingleChildScrollView(
        child:Container(
            padding: new EdgeInsets.all(32.0),
            child: new Center(
                child: new Column(
                    children:rl(state)
                )))

    );

  });





}