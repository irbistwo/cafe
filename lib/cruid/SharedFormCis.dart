import 'package:flutter/material.dart';
import 'package:cafe/Constants.dart';
//import 'package:cafe/main.dart';
import 'package:cafe/sp/SPcis.dart';


class SharedFormCis extends StatefulWidget {
  SP? sp;
  //BuildContext contextl;
  SharedFormCis(Map<SpDescribe,dynamic> msp){
    //  super();
    sp=new SP(msp);
  }

  @override
  _SharedFormCisState createState() => new _SharedFormCisState();
}

class  _SharedFormCisState extends State<SharedFormCis>  {
  //static const String routeName = "/settingui";

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  void showMessage(String message, [MaterialColor color = Colors.green]) {

    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));

    // HomePage.showMessage(message,color);
    //sp.printl();
    //print('OK');
    // final snackBar = SnackBar(content: Text(message),backgroundColor: color);

// Find the Scaffold in the Widget tree and use it to show a SnackBar
    //Scaffold.of(this.context).showSnackBar(snackBar);

  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;

    if (!form!.validate()) {
      showMessage( 'Form is not valid!  Please review and correct.',Colors.red);
      return;
    }

    form.save();
    // SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    // saveprefvalue();
    showMessage('Параметры сохранены');
    Constants.clear();
  }
  @override
  Widget build(BuildContext context) {
    widget.sp?.submitForm=_submitForm;
    return new Scaffold(
        key:_scaffoldKey,
        // AppBar
        appBar: new AppBar(
          // Title
          title: new Text("Страница настроек"),
          // App Bar background color
          backgroundColor: Colors.blue,
        ),
        // Body
        body:new Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: widget.sp!.fb()
        ),
        floatingActionButton:new BackButton(color: Colors.black45)
    );
  }
}
