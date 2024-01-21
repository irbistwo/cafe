
import 'dart:io';

import 'package:cafe/Contents/ContentsGUI.dart';
import 'package:cafe/Contents/ContentsGoodsBloc.dart';
import 'package:cafe/Contents/ContentsModel.dart';
import 'package:cafe/Contents/SectionButtonModel.dart';
import 'package:cafe/cruid/WidgetBlock.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:flutter/material.dart';

//import 'package:cafe/cruid/TopicListItem.dart';

//import 'package:cafe/models/FirmsModel.dart';


import '../Constants.dart';
typedef  CallBackIndex(int index);
class ReestrBlocGUI extends WidgetBloc{
final cisBloc bloc;
  ReestrBlocGUI(this.bloc,CallBackIndex callBackIndex):super(title:"Зал",bloc:bloc,listviewbuilder:(List _listfiltered,WidgetBlocState state){
    // final String statusimgcompleted="img/completeupload.png";
    final String statusimgcommon="img/44.png";
    //final String statusimgtosend="img/journal_msg.png";
    return ListView.builder(
       scrollDirection: Axis.vertical,
        itemCount:_listfiltered.length,
        itemBuilder:(context, index){
          String aseetpathimg=statusimgcommon;

          return
            Container (
                //width: 100,
                decoration: new BoxDecoration (
                    color: (index==state.value?state.color:null)
                ),   child:
            new ListTile(
              key: ObjectKey(index.toString()),
            
              //isThreeLine:true,
              title: Text(_listfiltered[index].lastgoods??"НЕТ ЗАКАЗА",style: TextStyle(fontSize: 10,color:Colors.yellow[400])),
              subtitle: Text('N${_listfiltered[index].no?.toString()??""} Стол ${_listfiltered[index].place1?.toString()??""}'),
             // trailing:Text(_listfiltered[index].packname??""),
                trailing: Text(_listfiltered[index].summsellcost?.toString()??"",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
              selected: (index==state.value),
              onTap: () async{
                bool popup=false;
                if(state.value==index) popup=true;
                state.setState((){
                  state.value=index;
                });
                     
                if(popup) //Navigator.of(context).pushNamed('/settingui');
                    {
                      ContentsGoodsBloc cgbloc=new ContentsGoodsBloc(document_id:_listfiltered[index].id );
                     await cgbloc.load();
                         SectionButtonModel.loadfromAPIgoods();
        await  SectionButtonModel.loadfromAPI();
        int seq=ContentsModel.get_seq();
ContentsGUI contents=new ContentsGUI(seq:seq+1,document_id:_listfiltered[index].id,cgbloc:cgbloc,title: "Заказ №${_listfiltered[index].no} столика ${_listfiltered[index].place1} ${Constants.garsonrow?.name}",);
   var result=await       Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => contents,
                   ),
           );
          
                bloc.load();
               
                  
                }
                // Map<SpDescribe,dynamic> msp=widget.xmlDesc.msp[_list[index]];



              },
              onLongPress: (){
                //  print(_list[index].id);

              },
            )


            );
        }
    );

  });

   

}