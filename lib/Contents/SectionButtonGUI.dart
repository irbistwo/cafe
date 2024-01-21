import 'package:cafe/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cafe/Constants.dart';
import 'dart:async';

import 'SectionButtonModel.dart';
class SectionButtonGUI extends StatefulWidget {
 final StreamController? ctrl;
  final StreamController? ctrltosevtion;
final Clickbutton? clickbutton;
  const SectionButtonGUI({Key? key, this.ctrl,this.ctrltosevtion,this.clickbutton}) : super(key: key);
_SectionButtonGUIState createState()=>new _SectionButtonGUIState();
}

class _SectionButtonGUIState  extends State<SectionButtonGUI> {
 List<SectionButtonModel> _list=[];
 late StreamSubscription subscription ;
  int _page=0;
  int parent_id=0;
   late double itemHeight;
   late double itemWidth;
    List<Map<String,int>> _menuqueue=<Map<String,int>>[];

     @override
  void initState() {
   
    // _list=TitleModel.titles;
   // _list=SectionModel.items;
    super.initState();
    
    _list=SectionButtonModel.getPage(_page);
    _menuqueue.add({"page":_page,"parent_id":parent_id});
    //ctrl.stream.


  }
  void _doSinc(data){
    print(data);
   switch (data){
   case 0:
  setState(() {
    _page=0;
    parent_id=0;
     _list=SectionButtonModel.getPage(_page);
      _menuqueue.clear();
     _menuqueue.add({"page":_page,"parent_id":parent_id});
  });
     break;
     default:
      setState(() {
      _page=0;
    parent_id=data;
     var  list=SectionButtonModel.getParentmenu(SectionButtonModel.itemsall!, parent_id);
     _list=SectionButtonModel.getParentmenu(list, parent_id);
      _menuqueue.clear();
     _menuqueue.add({"page":_page,"parent_id":parent_id});
     });
   }
  }
@override
void didChangeDependencies(){
    super.didChangeDependencies();
  var size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight ) / 2-30;
     itemWidth = size.width / 2;
     // if(subscription==null)
        subscription= widget.ctrltosevtion!.stream.listen(_doSinc);
}

 Iterable<Widget> get sectionWidgets sync* {
    int i=0;

    for (SectionButtonModel goods in _list) {
      yield get_row(i);
      i++;
    }

  }

   Widget get_row(int index){
    IconData icon=Icons.filter_1;
    IconData icon1=Icons.filter;
    //print("$index,${_list[index].sectionname}");
    var i=index;
    if(_page!=0) i--;
    switch (_list[index].id){
      case -1:icon=Icons.cloud_upload;break;
      case -2:icon=Icons.cloud_download;break;
      default:icon=Constants.getByIndex(i);
    }
    VoidCallback ontap=(){
      doitem(index);
   // widget.controller.animateTo(2);
    };
  if(_list[index].id==-2)  ontap=nextpage;
    if(_list[index].id==-1)  ontap=prevpage;
    Color? colorq=Colors.blue[400];
    if(_list[index].iamgoods==1) colorq=Colors.pink[300];
    return new InkWell(
      onTap: ontap,
   splashColor: Colors.white,
            highlightColor: Colors.white,



   child:  Container(
        color: colorq,
        margin: EdgeInsets.all(2.0),
    child:GridTile(
      /*
      footer: Text(
        _list[index].sectionname,
        textAlign: TextAlign.center,
      ),
      */
      header: Text(
        _list[index].sectionname!,
        textAlign: TextAlign.center,
      ),
      child: Icon(icon,
          size: 40.0, color: Colors.white30),
    )
    )

    );
  }
  GridView get grid {

    return new GridView.count(
      
     // controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          
            childAspectRatio: (itemWidth / itemHeight),
          //   maxCrossAxisExtent: 200,
      //  mainAxisSpacing: 5,
      //  crossAxisSpacing: 5,
        crossAxisCount: 4,
       // scrollDirection: Axis.horizontal,
        //scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(5),
        children: sectionWidgets.toList()//buildgridtitles(12)
    );
  }

  void nextpage(){
    setState(() {
      parent_id=0;
      _page++;
      _list=SectionButtonModel.getPage(_page);
      _menuqueue.add({"page":_page,"parent_id":0});
     // print(_menuqueue.length);
    });
  }

  void prevpage(){
    setState(() {
      parent_id=0;
      _page--;
      _list=SectionButtonModel.getPage(_page);
      _menuqueue.add({"page":_page,"parent_id":0});
    });
  }

  void doitem(int index) async{
    int parent_id=_list[index].id!;
  var  list=SectionButtonModel.getParentmenu(SectionButtonModel.itemsall!, parent_id);

    if(list.length!=0) {
      _menuqueue.add({"page": _page, "parent_id": parent_id});
      var  list2=SectionButtonModel.get_breadcrumbarray(SectionButtonModel.itemsall!, parent_id);
    widget.ctrl?.sink.add(list2);
     // print(list2);
      setState(() {
        //Чтоб перересовалось
        _list=list;
      });
      return;
    }
    print(_list[index]);
    //Нет вложенногог меню поднимаем goodsview
    int section_id =_list[index].section_id!;
    var listgoods=await SectionButtonModel.getGoods(section_id);
    if(_list[index].iamgoods==1) addinAPI(_list[index].id!);
    setState(() {
      _list=listgoods;
    });
    
      
      }

      void addinAPI(int goods_id) {
        widget.clickbutton!(goods_id,context);

      }
    
      @override
      Widget build(BuildContext context) {
       return grid;
      }
      void dispose() {
        subscription.cancel();
        print("dispose");
        super.dispose();
       
      }
    
      
}