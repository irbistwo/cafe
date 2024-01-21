
import 'package:cafe/cruid/WidgetBlock.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:flutter/material.dart';

//import 'package:cafe/cruid/TopicListItem.dart';

//import 'package:cafe/models/FirmsModel.dart';


import 'ContentsModel.dart';
typedef  CallBackIndex(ContentsModel row);
class ContentsGoodsBlocGUI extends WidgetBloc{
final cisBloc bloc;
//final StreamController ctrl;
  ContentsGoodsBlocGUI(this.bloc,CallBackIndex callBackIndex,ctrl):super(ctrl:ctrl,title:"Контекст",bloc:bloc,
      listviewbuilder:(List _listfiltered,WidgetBlocState state){
     final String statusimgcompleted="img/completeupload.png";
    final String statusimgcommon="img/44.png";
    //final String statusimgtosend="img/journal_msg.png";

List _list=_listfiltered;

 Widget _get_servicerow(int index){
    String aseetpathimg=statusimgcompleted;
    MaterialColor colorquant= Colors.grey;

    return  new Column (
        children:[
          new  Container (
              decoration: new BoxDecoration (
                  color: colorquant
              ),   child:

          new ListTile(
            key: ObjectKey(index.toString()),
            leading: CircleAvatar(
              //backgroundImage: NetworkImage(profile.imageUrl),
              backgroundImage: AssetImage(aseetpathimg),
              backgroundColor: Colors.white,
              maxRadius: 15,
            ),
            title: Text(_list[index].goodsname??"-"),
            
            selected: (index==state.value),
            onTap: (){

           
              /*
              bool popup=false;
              if(_value==index) popup=true;
              setState((){
                _value=index;
              });

              if(popup) //Navigator.of(context).pushNamed('/settingui');
                  {
                _goodsmodyfy(_list[index]);

              }
              */

            },
            onLongPress: (){
              //Navigator.pop(context, _list[index].id);
              //  print(_list[index].id);

            },
          )//Title



          )//Container
          ,
          // new Divider()
        ]);//column

  }

  Widget _get_row(int index){
  String aseetpathimg=statusimgcommon;
  if((_list[index].countprint??0)==0) aseetpathimg="img/upload.png";
  MaterialColor colorquant= Colors.yellow;
  if((_list[index].quantity??0)<0) colorquant= Colors.orange;
  Color? colorindex=Colors.white;
switch(_list[index].barindex??0){
case 0:break;
case 1:break;
case 2:colorindex=Colors.blue[400];break;
case 3:colorindex=Colors.pink[200];break;
case 4:colorindex=Colors.yellow[100];break;
case 5:colorindex=Colors.blue[50];break;
}
  
   return  new Column (
  children:[
  new  Container (

                decoration: new BoxDecoration (
                    color: (index==state.value?state.color:null)
                ),   child:

            new ListTile(
              key: ObjectKey(index.toString()),
              leading: CircleAvatar(
                //backgroundImage: NetworkImage(profile.imageUrl),
                backgroundImage: AssetImage(aseetpathimg),
                backgroundColor: colorindex,
                maxRadius: 20,
              ),
              title: Text(_list[index].goodsname??"-",style: TextStyle(fontSize: 14)),
              subtitle:
new Row(
  children: [CircleAvatar(
  backgroundColor: colorquant,
  maxRadius: 15,
   child: new Text("${_list[index].quantityformated}")
  //radius: 28,
  ),
  new Padding(padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
  child:new Text("x${_list[index].prsellcostformated}")
  )]),
              trailing: Text(_list[index].summaformated,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
              selected: (index==state.value),
              onTap: (){
                   callBackIndex(_list[index]);
                bool popup=false;
                if(state.value==index) popup=true;
                state.setState((){
                  state.value=index;
                });

                if(popup) //Navigator.of(context).pushNamed('/settingui');
                    {
                     // _goodsmodyfy(_list[index]);

                }

              },
              onLongPress: (){
  //Navigator.pop(context, _list[index].id);
        //  print(_list[index].id);

    },
            )//Title



            )//Container
  ,
 // new Divider()
  ]);//column

  }



Iterable<Widget>  goodsWidgets() sync* {
 int i=0;
 var divivder=new Divider(
  color: Colors.yellow,
  );
  for (ContentsModel goods in _listfiltered) {
    Widget w;
    if(goods.is_servicefield!) w=_get_servicerow(i);
    else w=_get_row(i);
    yield w;
    i++;
  }

  };

  return new ListView(
children: goodsWidgets().toList()
);
      
  });
  

}