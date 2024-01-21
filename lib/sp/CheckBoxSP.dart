import 'package:flutter/material.dart';

class CheckBoxSP extends FormField<bool> {
   CheckBoxSP  ({
    Key? key,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false,
     Icon? icon,
    required String caption,
     required  String describe
  }):assert(caption!=null),
   assert(describe != null),
       super(
  onSaved: onSaved,
  validator: validator,
  initialValue: initialValue,
  autovalidateMode: AutovalidateMode.always,
  builder: (FormFieldState<bool> state) {
   return  new Container(
    padding: new EdgeInsets.all(0.0),
    child: new Center(
      child: new Column(
        children: <Widget>[
            new CheckboxListTile(
              key:key,
            value: state.value,
              onChanged: state.didChange,
            /*
            onChanged:(bool b){
            state.didChange(b);
            },*/
            title: new Text(caption),
            controlAffinity: ListTileControlAffinity.leading,
            subtitle: new Text(describe),
            secondary:icon,
            activeColor: Colors.green,
          ),
        ],
      ),
    ),
  );

  }
   );
}