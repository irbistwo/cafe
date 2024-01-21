
import 'dart:io';

import 'package:cafe/cruid/WidgetBlock.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:flutter/material.dart';

//import 'package:cafe/cruid/TopicListItem.dart';

//import 'package:cafe/models/FirmsModel.dart';


import '../Constants.dart';
typedef  CallBackIndex(int index);
class HollButton_blockGui extends WidgetBloc{
final cisBloc bloc;
  HollButton_blockGui(this.bloc,initindex,CallBackIndex callBackIndex):super(title:"Зал",initIndex:initindex,bloc:bloc,listviewbuilder:(List _listfiltered,WidgetBlocState state){
    // final String statusimgcompleted="img/completeupload.png";
    final String statusimgcommon="img/calendar.png";
    //  Symbol names=new Symbol("_list[index].name");
    // final String statusimgtosend="img/journal_msg.png";
    return ListView.builder(
       scrollDirection: Axis.horizontal,
        itemCount:_listfiltered.length,
        itemBuilder:(context, index){
          String aseetpathimg=statusimgcommon;

          return
            Container (
                width: 200,
                decoration: new BoxDecoration (
                    color: (index==state.value?state.color:null)
                ),   child:
            new ListTile(
              key: ObjectKey(index.toString()),
              leading: CircleAvatar(
                //backgroundImage: NetworkImage(profile.imageUrl),
                backgroundImage: AssetImage(aseetpathimg),
                backgroundColor: Colors.white,
                maxRadius: 25,
                //radius: 28,
              ),
              title: Text("${_listfiltered[index].name}"),
            //  subtitle: Text(_listfiltered[index].inn??""),
             // trailing:Text(_listfiltered[index].packname??""),
              //  trailing: Text(_list[index].summaformated,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
              selected: (index==state.value),
              onTap: () async{
                bool popup=false;
                if(state.value==index) popup=true;
                state.setState((){
                  state.value=index;
                });
                        //print(_listfiltered[index].id);
                        _saveHollid(_listfiltered[index].id.toString());
                        callBackIndex(_listfiltered[index].id);
                if(popup) //Navigator.of(context).pushNamed('/settingui');
                    {
                  
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

  //void _firmsmodyfy(dynamic item){}


 
 static void _saveHollid(String contents){
    String tempPath= Constants.tempDir!.path;
  final file=File('$tempPath/hollid');
      file.writeAsString(contents);
 }   
      

}