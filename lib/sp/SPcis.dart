import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cafe/sp/CheckBoxSP.dart';
import 'package:cafe/sp/RadioListSP.dart';
//import 'package:flutter/services.dart' show rootBundle;

/*this class for describe field (text or checkbox or radiobutton)*/
class SpDescribe extends Object {
  final String? name;
  final Type? type;
  final List<String>? uiname;
  final int icon;
 const SpDescribe({@required this.name,this.type=String,this.uiname,this.icon =0xe8b9});
}

typedef void SavedSp(dynamic val,String name);
/*this class encapsulated work with SharedPreferences */
class SP extends Object{
//  Map<String,dynamic> _msp={"urldownload":"",'urldownload1':'','urldownload2':''};
  Map<SpDescribe,dynamic>? _msp;
  /*Theare list windget to been build*/
  List<Widget>? list=[];

  VoidCallback? submitForm;

  SavedSp? _onSaved=(dynamic val,String name) async{
  SharedPreferences?   sharedPreferences = await SharedPreferences.getInstance();

 /* bool b= await*/
 switch(val.runtimeType) {
   case String: sharedPreferences.setString(name, val);break;

   case bool: sharedPreferences.setBool(name, val);
   print('${name}: ${val}');
   //dynamic d=  sharedPreferences.get(name);
   //print('${name}: ${d}');
   break;
   case int:
     sharedPreferences.setInt(name, val);
  // print('${name}: ${val}');
   //dynamic d=  sharedPreferences.get(name);
   //print('${name}: ${d}');
   break;
  }
  };


  SP(Map<SpDescribe,dynamic> msp){
//super();
  this._msp=msp;
  }




  Future _futuregetsp(pref) async {
    return (await SharedPreferences.getInstance()).get(pref);
  }



  Future<List<Widget>> preparemapf() async{
    List<Widget> list=[];
    _msp?.forEach((n,v) async {
      dynamic d= await _futuregetsp(n.name);

      _msp?[n]=d;
    switch (n.type) {
      case String:
        if(d==null) d=v;
        Widget spwidget = _get_spwidget(n, d);
      list.add(spwidget);
      break;
      case bool:
        bool chb=(_msp?[n]==null?false:_msp?[n]);
        Widget spwidget2 = _get_spwidgetcb(n, chb);
        list.add(spwidget2);
        break;
      case List:
        int chb=(_msp?[n]==null?0:_msp?[n]);
        //print(chb);
        //print(n.list.length);
        Widget spwidget3 = _get_spwidgetrl(n, chb);
        list.add(spwidget3);
        break;
    }
    //  mpkey[spwidget.key]=d;

    });
    return list;

  }

  FutureBuilder<List<Widget>> fb() {
 return new FutureBuilder<List<Widget>>(
 future: preparemapf(),
  builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
   List<Widget>? lw=(snapshot.data==null?[]:snapshot.data);
   lw?.add(new Container(
       padding: const EdgeInsets.only(left: 40.0, top: 20.0),
       child: new ElevatedButton (
         child: const Text('Сохранить'),
         onPressed: submitForm,
       )));
  return  ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
    // ignore: use_of_void_result
    children:lw!//(snapshot.data==null?[]:snapshot.data)
  );
  });
}

 Widget _get_spwidget( SpDescribe sdesc,dynamic value){
 //  final TextEditingController _controller = new TextEditingController();
   TextInputType keyboardType=TextInputType.url;
  // _controller.text=(value==null?'':value);
  String label=(sdesc.uiname?[0]==null?"":sdesc.uiname![0]);
  //int inticon= int.parse("0xe0e4");
   return new TextFormField(
    key:new ObjectKey(sdesc.name),
       decoration:  InputDecoration(
         icon:  Icon(IconData(sdesc.icon,fontFamily: 'MaterialIcons')),//Icon(Icons.calendar_today),
         hintText: 'Введите '+label,
         labelText:label,// ('URL загрузки'+"jj"+n),
       ),
     initialValue:(value==null?'':value) ,
     //  controller: _controller ,
       keyboardType: keyboardType,
       onSaved: (val) => _onSaved!(val,sdesc.name!)//_paramvalue = val
   );

 }


  Widget _get_spwidgetcb( SpDescribe sdesc,bool value_){
    return new CheckBoxSP(
        key:new Key(sdesc.name!),
        initialValue:value_,
       icon:  Icon(IconData(sdesc.icon,fontFamily: 'MaterialIcons')),
        caption: sdesc.uiname![0],
        describe:sdesc.uiname![1] ,
        onSaved: (val) => _onSaved!(val,sdesc.name!)
    );

  }

  Widget _get_spwidgetrl( SpDescribe sdesc,int value_){
    return new RadioListSP(
        key:new Key(sdesc.name!),
        initialValue:value_,
        rlistui: sdesc.uiname!,
        onSaved: (val) => _onSaved!(val,sdesc.name!)
    );

  }
/*
  static Future<String> loadXml() async {
    return await rootBundle.loadString('xmlsp/flutsp1.xml');
  }
  */

}

