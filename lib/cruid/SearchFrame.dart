import 'package:flutter/material.dart';
import 'package:cafe/dictionarycis/SearchGUI.dart';
import 'package:cafe/models/SearchHelper.dart';


class SearchFrame extends FormField<int>{
final  String? initname;
final  String? sql;
 // final TextEditingController _controller = new TextEditingController();
  SearchFrame({
  Key? key,
      FormFieldSetter<int>? onSaved,
       FormFieldValidator<int>? validator,
      int initialValue=-1,
      this.initname,
      this.sql,
       bool autovalidate = false,
      Icon? icon,
  required String caption,
  required  String describe
}):assert(caption!=null),
assert(describe != null),
super( onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder:(FormFieldState<int> field){

  _SearchFrameState state=field as  _SearchFrameState ;
  return
    new Column(
        children: <Widget>[
          new Text(caption),
          new TextField(
              decoration: new InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  ),
              //  hintText: 'Tell us about yourself',
              //  labelText: 'Life story',

              ),
              enableInteractiveSelection: false,
              onTap: () async{ FocusScope.of(state.context).requestFocus(new FocusNode());
              //
              SearchGUI searchwidget=new SearchGUI(sql!);
              SearchHelper sh= await  Navigator.push(state.context, MaterialPageRoute(
                  builder: (context) =>searchwidget,
                ),
              );
              if(sh==null) return;
              state._controller.text=sh.name!;
              state.didChange(sh.id);

              //print("tap");
             // state._controller.text="rap";
              },

              controller: state._controller)]
    );

          }
      );
  @override
  _SearchFrameState createState()=>_SearchFrameState();
}

class _SearchFrameState extends FormFieldState<int>{
  late TextEditingController _controller;
  @override
  SearchFrame get widget => super.widget as SearchFrame;
  @override
  void initState() {
    super.initState();

      _controller = TextEditingController(text: widget.initname);

  }

}