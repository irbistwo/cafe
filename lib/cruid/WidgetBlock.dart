import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';



typedef ListView Listviewbuilder(List list,WidgetBlocState state);
class emptyrow{
  int? id;
}
class WidgetBloc extends StatefulWidget {
 final StreamController? ctrl;
  final String? title;
  final cisBloc? bloc;
  int? initIndex=0;
  final Listviewbuilder? listviewbuilder;

  WidgetBloc({this.title,this.initIndex,@required this.bloc,this.listviewbuilder,this.ctrl});
  @override
  WidgetBlocState createState() => WidgetBlocState();
}

class WidgetBlocState<T> extends State<WidgetBloc> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _listfiltered=[];
  String _search="";
  StreamSubscription? subscription ;
  TextEditingController filtercontroller = new TextEditingController();
  int value = -1;
  Color color=Color.fromARGB(89, 0, 67, 6);
  void initState() {
    if(widget.initIndex==null) widget.initIndex=0;
value = widget.initIndex!;
    //print(xmlDesc.msp);
    //print(_list);
    super.initState();
  //  widget.bloc.load();
    // print(T.runtimeType);


  }

    @override
void didChangeDependencies(){
    super.didChangeDependencies();
  if(subscription==null)    
  if(widget.ctrl!=null) subscription= widget.ctrl?.stream.listen(_doBroadcast);
}

 void _doBroadcast(data){
    print(data);
   // if (instanceof(data, List<SectionButtonModel>))
     setState(() {
      value=data;
    });

  }

  void set_value(int index){
setState(() {
  value=index;
});
  }

  void _filterlist(String search) async{
    _search=search;
    widget.bloc?.filter(search);
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
          return Center(child: Text('Нет Записей'));
        }
        _listfiltered=results;

        return widget.listviewbuilder!(_listfiltered,this);
      },
    );

  }
 @override
  void dispose() {
    subscription?.cancel();
    print("dispose widgetBlockGui");
    super.dispose();
   
  }
 
  @override
  Widget build(BuildContext context) {
    return(mounted==true ?_buildResults(widget.bloc!)
    : new Container());
  }
}