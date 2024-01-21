import 'package:flutter/material.dart';
import 'package:cafe/dictionarycis/bloc/SearchBloc.dart';
//import 'package:cafe/cruid/TopicListItem.dart';
//import 'package:cafe/models/FirmsModel.dart';
import 'package:cafe/cruid/CruidblocGUI.dart';
import 'package:cafe/models/SearchHelper.dart';


class SearchGUI extends CruidBlocGUI{
  SearchGUI(String sql):super(title:"Поиск и Выбор",bloc:new searchBloc(sql),listviewbuilder:(List _listfiltered,CruidBlocGUIState state){
    // final String statusimgcompleted="img/completeupload.png";
    final String statusimgcommon="img/complete.png";
    //  Symbol names=new Symbol("_list[index].name");
    // final String statusimgtosend="img/journal_msg.png";
    return ListView.builder(
        itemCount:_listfiltered.length,
        itemBuilder:(context, index){
          String aseetpathimg=statusimgcommon;

          return
            Container (

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
             // subtitle: Text(_listfiltered[index].inn??""),
              // trailing:Text(_listfiltered[index].packname??""),
              //  trailing: Text(_list[index].summaformated,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
              selected: (index==state.value),
              onTap: () async{
                bool popup=false;
                if(state.value==index) popup=true;
                state.setState((){
                  state.value=index;
                });
  SearchHelper sh=new SearchHelper(id:_listfiltered[index].id,name:_listfiltered[index].name);
  Navigator.pop(context,sh);

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



}