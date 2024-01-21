import 'package:flutter/material.dart';
import 'package:cafe/utils/settingui.dart';
import 'package:cafe/sp/SPcis.dart';
import 'package:cafe/sp/xml_flut.dart';
/*there ui of list titles of shared preferences same as "Настройка путей","Настройка загрузки" */
class SettingList extends StatefulWidget {
  XmlDesc xmlDesc=new XmlDesc(maintag:"document", tag:"title");
  @override
  _SettingListState createState() => _SettingListState();
}

class _SettingListState extends State<SettingList> {

 List<String> _list=[];//["Настройка путей","Настройка загрузки","Тип сканера","Настройка сканера"];
 int _value = -1;
 Color _color=Color.fromARGB(89, 0, 67, 6);
 @override
  void initState() {
    _list=widget.xmlDesc.msp.keys.toList();
    //print(xmlDesc.msp);
    //print(_list);
   super.initState();

  }

  ListView get _listviewbuilder{
    return ListView.builder(
        itemCount:_list.length,
      itemBuilder:(context, index){
          if(widget.xmlDesc.iconlist==null) return new Container();
          if(widget.xmlDesc.iconlist.length==0) return new Container();
//print(widget.xmlDesc.iconlist[index]);
        return
          Container (
            decoration: new BoxDecoration (
            color: (index==_value?_color:null)
        ),   child:
         new ListTile(
          key: ObjectKey(index.toString()),
          leading: CircleAvatar(
            //backgroundImage: NetworkImage(profile.imageUrl),
            backgroundImage: AssetImage(widget.xmlDesc.iconlist[index]),
            backgroundColor: Colors.white,
            maxRadius: 25,
          ),
          title: Text(_list[index]),
          subtitle: Text(_list[index]),
         selected: (index==_value),
          onTap: (){
            bool popup=false;
            if(_value==index) popup=true;
            setState((){
            _value=index;
          });

            if(popup) //Navigator.of(context).pushNamed('/settingui');
              {
              Map<SpDescribe, dynamic>? msp=widget.xmlDesc.msp[_list[index]];


              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingUIPage(msp!),
                ),
              );
             
              /*
              Navigator.pushNamed(
                  context,SettingUIPage.routeName);
              */

            }

            },
        )


                );
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return _listviewbuilder;
    /*
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [_listviewbuilder]
    );
    */
  }
}