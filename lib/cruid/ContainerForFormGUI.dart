import 'package:flutter/material.dart';
import 'package:cafe/cruid/FormDesc.dart';
import 'package:cafe/sp/SPcis.dart';

class ContainerForFormGUI extends StatefulWidget {
  FormDesc? sp;
  final String? sql;
  final String? sqldelete;
  final List<String>? argname;
  final List? idarray;
  ContainerForFormGUI({required Map<SpDescribe,dynamic> msp,this.sql,this.sqldelete,this.argname,this.idarray}): sp=new FormDesc(msp,argname!);
  @override
  _ContainerForFormGUIState createState() => _ContainerForFormGUIState();
}

class _ContainerForFormGUIState extends State<ContainerForFormGUI> {
  Color _colortitle=Colors.blue;
  int _deletestatus=0;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showMessage(String message, [MaterialColor color = Colors.green]) {
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() async{
    final FormState? form = _formKey.currentState;

    if (!form!.validate()) {
      showMessage( 'Form is not valid!  Please review and correct.',Colors.red);
      return;
    }

    form.save();
    // SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    // saveprefvalue();

    List resarray=List.of(widget.sp!.argvalueordered as Iterable);
    resarray.addAll(widget.idarray as Iterable);
    print(resarray);
    try {
     
      //return res;
    }
    catch (e) {
      print(e);
     // return -1;
      showMessage("Проблема транзакции", Colors.red);
      return;
    }

  //  showMessage('Реестр изменён');
    Navigator.pop(context,1);
  //  Constants.clear();
  }
  void _delstate() async{
    switch (_deletestatus ){
      case 0:_deletestatus=1;
      showMessage("Нажмите ещё раз для удаления",Colors.red);
      setState(() {
        _colortitle=Colors.red;
      });
      break;
      case 1:try {
      
        Navigator.pop(context,1);
        //return res;
      }
      catch (e) {
        print(e);
        // return -1;
        showMessage("Проблема транзакции", Colors.red);
        return;
      }
    }



  }
  @override
  Widget build(BuildContext context) {
    widget.sp?.submitForm=_submitForm;
    return new Scaffold(
        key:_scaffoldKey,
        // AppBar
        appBar: new AppBar(
          // Title
          title: new Text("Изменить,Удалить"),
          // App Bar background color
          backgroundColor: _colortitle,
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.delete_forever),
                 iconSize:40.0,
                onPressed: (){
                _delstate();
                         },
              )]
        ),
        // Body
        body:new Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: widget.sp!.form()
        ),
        floatingActionButton:new BackButton(color: Colors.black45)
    );

  }

}