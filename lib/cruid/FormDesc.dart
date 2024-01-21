import 'package:cafe/cruid/SearchFrame.dart';
import 'package:cafe/sp/SPcis.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cafe/sp/CheckBoxSP.dart';
import 'package:cafe/sp/RadioListSP.dart';

typedef void SavedForm(dynamic val,String name,List<String> paramname,List result);
class FormDesc extends Object {
  FormDesc(Map<SpDescribe,dynamic> msp, List<String> argname){
    this._msp=msp;
  this._argname=argname;
    argvalueordered=[(argname.length)];
  }

  Map<SpDescribe,dynamic>? _msp;
   /*Theare list windget to been build*/
 // List<Widget> list=[];
  List<String>? _argname;
  List? argvalueordered;
  VoidCallback? submitForm=(){};


 SavedForm _onSaved=(dynamic val,String name,List<String> paramname,List result) {

print('$name=$val');
var i=paramname.indexOf(name);
result[i]=val;


  };
  List<Widget> _preparemapform(){
    List<Widget> list=[];
    dynamic d;
    _msp?.forEach((n,v){
      switch (n.type) {
        case String:
         // if(d==null) d=v;
       // d=v;
          Widget spwidget = _get_spwidget(n, v);
          list.add(spwidget);
          break;
        case bool:
          bool chb=(_msp?[n]==null?false:_msp![n]);
          Widget spwidget2 = _get_spwidgetcb(n, chb);
          list.add(spwidget2);
          break;
        case List:
          int chb=(_msp?[n]==null?0:_msp![n]);
          //print(chb);
          //print(n.list.length);
          Widget spwidget3 = _get_spwidgetrl(n, chb);
          list.add(spwidget3);
          break;
        case SearchFrame:
         // int chb=(_msp[n]==null?-1:_msp[n]);
          int chb=_msp?[n];
          //print(chb);
          //print(n.list.length);
          Widget spwidget4 = _get_spwidgetSearchFrame(n, chb);
          list.add(spwidget4);
          break;
      }

    });
    return list;
  }

  ListView form(){
    List<Widget> lw=_preparemapform();
    lw.add(new Container(
        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
        child: new ElevatedButton (
          child: const Text('Сохранить'),
          onPressed: submitForm,
        )));
    return  ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // ignore: use_of_void_result
        children:lw//(snapshot.data==null?[]:snapshot.data)
    );
  }

  Widget _get_spwidget( SpDescribe sdesc,dynamic value){
   // final TextEditingController _controller = new TextEditingController();
    TextInputType keyboardType=TextInputType.url;
  //  _controller.text=(value==null?'':value);
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
        onSaved: (val) => _onSaved(val,sdesc.name!,_argname!,argvalueordered!)//_paramvalue = val
    );

  }


  Widget _get_spwidgetcb( SpDescribe sdesc,bool value_){
    return new CheckBoxSP(
        key:new Key(sdesc.name!),
        initialValue:value_,
        icon:  Icon(IconData(sdesc.icon,fontFamily: 'MaterialIcons')),
        caption: sdesc.uiname![0],
        describe:sdesc.uiname![1] ,
        onSaved: (val) => _onSaved(val,sdesc.name!,_argname!,argvalueordered!)
    );

  }

  Widget _get_spwidgetrl( SpDescribe sdesc,int value_){
    return new RadioListSP(
        key:new Key(sdesc.name!),
        initialValue:value_,
        rlistui: sdesc.uiname,
        onSaved: (val) => _onSaved(val,sdesc.name!,_argname!,argvalueordered!)
    );

  }

  Widget _get_spwidgetSearchFrame( SpDescribe sdesc,int value_){
    String label=(sdesc.uiname?[0]==null?"":sdesc.uiname![0]);
    String name=(sdesc.uiname?[1]==null?"":sdesc.uiname![1]);
    String sql=(sdesc.uiname?[2]==null?"":sdesc.uiname![2]);
    return new SearchFrame(
        key:new Key(sdesc.name!),
        initialValue:value_,
        initname: name,
        icon:  Icon(IconData(sdesc.icon,fontFamily: 'MaterialIcons')),
        caption: sdesc.uiname![0],
        describe:sdesc.uiname![1] ,
        sql: sql,
        onSaved: (val) => _onSaved(val,sdesc.name!,_argname!,argvalueordered!)
    );

  }

}