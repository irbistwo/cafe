import 'package:flutter/material.dart';
import 'package:cafe/models/ModelInterface.dart';



class CruidCisGUI<T extends ModelInterface> extends StatefulWidget {
  final String? title;
  T? model;
  CruidCisGUI({this.title,this.model});
  @override
  _CruidCisGUIState<T> createState() => _CruidCisGUIState<T>();
}

class _CruidCisGUIState<T> extends State<CruidCisGUI> {
  List<T> _list=[];
  List<T> _listfiltered=[];
  String _search="";
  TextEditingController filtercontroller = new TextEditingController();
  int _value = -1;
  Color _color=Color.fromARGB(89, 0, 67, 6);
  void initState() {

    //print(xmlDesc.msp);
    //print(_list);
    super.initState();
   // print(T.runtimeType);
    _list =widget.model!.list as List<T>;;
    _listfiltered =_list;

  }

  Future _refresh() async{
    var model=widget.model;
     await model!.load();
    _list=model!.list as List<T>;
   // print(_list.length);

  }
  void _filterlist(String search) async{
await _refresh();
setState(() {
  _listfiltered=_list;
});
  }
  Drawer get drawer {
    return new Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: new TextField(
                controller: filtercontroller,
                onChanged:_filterlist ,
                autofocus: true,
              ),
              trailing: Icon(Icons.face,color: Colors.blue),
              // subtitle: new Text("Фильтр"),


            )],
        )
    );
  }

  ListView get _listviewbuilder{
    if(!mounted) return new ListView();
    // final String statusimgcompleted="img/completeupload.png";
    final String statusimgcommon="img/price-tag.png";
    //  Symbol names=new Symbol("_list[index].name");
    // final String statusimgtosend="img/journal_msg.png";
    return ListView.builder(
        itemCount:_listfiltered.length,
        itemBuilder:(context, index){
          String aseetpathimg=statusimgcommon;
        //  Map<String, dynamic> toMap();
          return
            Container (

                decoration: new BoxDecoration (
                    color: (index==_value?_color:null)
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
              title: Text("${(_listfiltered[index] as ModelInterface).toMap()?["name"]}"),
              subtitle: Text("${(_listfiltered[index] as ModelInterface).toMap()?["name1"]}"),
              trailing:Text("${(_listfiltered[index] as ModelInterface).toMap()?["name2"]}"),
              //  trailing: Text(_list[index].summaformated,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
              selected: (index==_value),
              onTap: () async{
                bool popup=false;
                if(_value==index) popup=true;
                setState((){
                  _value=index;
                });

                if(popup) //Navigator.of(context).pushNamed('/settingui');
                    {
                  //  _firmsmodyfy(_listfiltered[index]);
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

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: new Text(widget.title!),
      ),
      body:_listviewbuilder,
drawer: drawer,

    );
  }
}