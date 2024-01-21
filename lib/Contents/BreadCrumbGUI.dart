import 'package:flutter/material.dart';
import 'package:cafe/Constants.dart';
import 'dart:async';
import '../HomeScreen.dart';
import 'SectionButtonModel.dart';

class BreadCrumbGUI extends StatefulWidget {
 final StreamController ctrl;
  final StreamController ctrltosevtion;
 BreadCrumbGUI({Key? key, required this.ctrl,required this.ctrltosevtion}) : super(key: key);
  _BreadCrumbGUIState createState()=>new _BreadCrumbGUIState();
  }

  
  
  class _BreadCrumbGUIState  extends State<BreadCrumbGUI> {
      StreamSubscription? subscription ;
       List<SectionButtonModel> list=[];
    Color colortap =Colors.deepPurple;
    bool taped=false;
    int _id=0;
 Widget rbuildButtonColumn(BuildContext context,String iconpath, String label,Clickbutton voidpress,int id) {
    Color? color = Theme.of(context).textTheme.headlineMedium?.color;
    Image image=  new Image.asset(
      iconpath,
      width: 40.0,
      height: 40.0,
      fit: BoxFit.contain,
    );
    var iconbutton= IconButton(
      icon: image,//Icon(Icons.volume_up),
    //  tooltip: 'Download dbfile%',
      iconSize:40.0,
      splashColor:Colors.green,
      disabledColor: Colors.red,
      onPressed: () async{
        voidpress(id,context);
// pressup();
        // uploadFile();
      },
    );



    return  
    InkWell(
      splashColor:Colors.white10,
    highlightColor: Colors.black,
      onTap: (){print('tap $id');
      _id=id;
      widget.ctrltosevtion.sink.add(id);
      setState(() {
        taped=true;
             });
      Future.delayed(Duration(milliseconds: 80), () {
        setState(() {
        taped=false;
             });
       });
      },
      child: Container ( 
        color:(taped&&_id==id)?colortap:Colors.transparent,
        child:
        Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        // raisedbutton,
       //  floatingActionButton,
       // iconbutton,
       image,
        // flatbutton,
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
        )
      )
    )
    ;


  }
Widget get_firstbuuton(BuildContext context,String iconpath,String title,Clickbutton callback,int id){
    return rbuildButtonColumn(context,iconpath, title,callback,id);
    
  }

 void ClickBreadcrumb(int id,BuildContext context){
   widget.ctrltosevtion.sink.add(id);
 }
  List<Widget>get_buttons(BuildContext context){
    List<Widget> result=<Widget>[];
Widget w= get_firstbuuton(context,'img/home.png', 'Меню',ClickBreadcrumb,0);
result.add(w);
list.forEach((row) {
   w= rbuildButtonColumn(context,'img/arowrg2.png', row.sectionname!,ClickBreadcrumb,row.id!);
   result.add(w);
 });
    return result;

  }

  @override
void didChangeDependencies(){
    super.didChangeDependencies();
  if(subscription==null)     subscription= widget.ctrl.stream.listen(_doMenu);
}
  void _doMenu(data){
    print(data);
   // if (instanceof(data, List<SectionButtonModel>))
     setState(() {
      list=data;
    });

  }
 void dispose() {
    subscription?.cancel();
    print("dispose");
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
  return new Row(children: get_buttons(context));
  }
}