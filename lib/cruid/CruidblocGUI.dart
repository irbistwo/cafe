import 'package:flutter/material.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:cafe/models/ModelInterface.dart';
import 'package:cafe/sp/SPcis.dart';

import 'ContainerForFormGUI.dart';


typedef ListView Listviewbuilder(List list,CruidBlocGUIState state);
class emptyrow{
  int? id;
}
class CruidBlocGUI extends StatefulWidget {
  final String? title;
  final cisBloc? bloc;
  final Listviewbuilder? listviewbuilder;

  CruidBlocGUI({this.title,@required this.bloc,this.listviewbuilder});
  @override
  CruidBlocGUIState createState() => CruidBlocGUIState();
}

class CruidBlocGUIState<T> extends State<CruidBlocGUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _listfiltered=[];
  String _search="";
  TextEditingController filtercontroller = new TextEditingController();
  int value = -1;
  Color color=Color.fromARGB(89, 0, 67, 6);
  void initState() {

    //print(xmlDesc.msp);
    //print(_list);
    super.initState();
    widget.bloc?.load();
    // print(T.runtimeType);


  }

  void _filterlist(String search) async{
    _search=search;
    widget.bloc?.filter(search);
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


            ),
          new Divider()],
        )
    );
  }

  Widget _buildResults(cisBloc bloc) {
    return StreamBuilder<List>(
      stream: bloc.streamlist,
      builder: (context, snapshot) {

        // 1
        //  print(snapshot.data);
        final results = snapshot.data;

        if (results == null) {
          return  new Container(
            alignment: Alignment.center,
           child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
           // verticalDirection: VerticalDirection.,
            crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              new CircularProgressIndicator(),
              Text(" "),
              Text("Loading...."),
            ],        ));
        }

        if (results.isEmpty) {
          return Center(child: Text('No Rows'));
        }
        _listfiltered=results;

        return widget.listviewbuilder!(_listfiltered,this);
      },
    );

  }
  void showMessage(String message, [MaterialColor color = Colors.green]) {
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
  void rowmodify({required Map<SpDescribe,dynamic> msp,required List<String> argnamefororeder,required String sql,required String sqldelete,dynamic conteximodel}) async{
    final result=await  Navigator.push(context,MaterialPageRoute(
      builder: (context) => ContainerForFormGUI(msp:msp,sql: sql,sqldelete: sqldelete,argname:argnamefororeder,idarray: [conteximodel.id], ), ),  );
     if((result??0)==1)  {
     await widget.bloc?.load();
      widget.bloc?.filter(_search);
          showMessage('Реестр изменён');

    }

  }
  Widget buildresult()=> _buildResults(widget.bloc!);
  @override
  Widget build(BuildContext context) {
    return(mounted==true ?
    Scaffold(
      key:_scaffoldKey,
      appBar:AppBar(
          title: new Text(widget.title!),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.note_add),
              // iconSize:60.0,
              onPressed: (){
              rowmodify(msp: widget.bloc!.msp! ,argnamefororeder:widget.bloc!.argnamefororeder!,sql: widget.bloc!.sqlinsert!,conteximodel:new emptyrow(), sqldelete: '' );
                    },
            )]
      ),
      body:  _buildResults(widget.bloc!),
      drawer: drawer,


    ): new Container());
  }
}