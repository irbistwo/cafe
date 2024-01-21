import 'dart:async';
import 'dart:convert';

import 'package:cafe/Contents/BreadCrumbGUI.dart';
import 'package:cafe/Contents/CloseOrderModel.dart';
import 'package:cafe/Contents/SectionButtonGUI.dart';
import 'package:cafe/Reestr/ReestrModel.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:cafe/utils/ApiRequest.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';
import 'ContentsGoodsBloc.dart';
import 'ContentsGoodsGUI.dart';
import 'ContentsModel.dart';
import 'UpdateContents.dart';

class ContentsGUI extends StatefulWidget {
  final ContentsGoodsBloc? cgbloc;
  final String title;
  final int document_id;
  int seq;
   ContentsGUI({Key? key, this.cgbloc, required this.title,required this.document_id,required int seq}) :this.seq=seq, super(key: key);
  @override
 _ContentsGUIState createState()=> _ContentsGUIState();

}

class _ContentsGUIState extends State<ContentsGUI>{
   ContentsModel? currentrow;
    StreamController ctrl= StreamController.broadcast();
     StreamController ctrltoSection= StreamController.broadcast();
       StreamController ctrltoContents= StreamController.broadcast();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
     void showMessage(String message, [MaterialColor color = Colors.green]) {
  
     // _scaffoldKey.currentState.showSnackBar(
       ScaffoldMessenger.of(_scaffoldKey.currentState!.context)..showSnackBar(
          new SnackBar(  duration: Duration(seconds: 4),backgroundColor: color, content: new Text(message)));
  
    }
/*Тут мы окажемся когда кнпка сиреневая товара нажата на доавление в контекст*/
    void _CallbackClickButtonGoods(int id,BuildContext context) async{

        String? dburl=Constants.dbendpoint;
              String url= '${dburl}/sqlexecute';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
  
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="goods_id";
    paramitem["type"]=0;
    paramitem["v"]=id;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="quantity";
    paramitem["type"]=0;
    paramitem["v"]=1;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="garson_id";
    paramitem["type"]=0;
    paramitem["v"]=Constants.garsonrow!.id;
    params.add(paramitem);

     paramitem=new Map<String,dynamic>();
      paramitem["name"]="vari";
    paramitem["type"]=0;
    paramitem["v"]=0;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="metadoc_id";
    paramitem["type"]=0;
    paramitem["v"]=widget.document_id;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="seq";
    paramitem["type"]=0;
    paramitem["v"]=widget.seq;
    params.add(paramitem);

     Map jsonMap={
        'sqlexec': 'addinAPI',
        'params':params,
       
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
        Map jsonres=json.decode(result);
        print(jsonres);
      int status=jsonres["id"];
      if(status==-1) showMessage(jsonres["status"],Colors.red);
      if(status==1) {await widget.cgbloc?.load();
      ctrltoContents.sink.add(1);
      currentrow=ContentsModel.rowstogui[1];
      }
    
    //  return result;
    

    }

      Widget  _buildSectionButton() {
return new SectionButtonGUI(ctrl: ctrl,ctrltosevtion: ctrltoSection,clickbutton: _CallbackClickButtonGoods);
      }
Widget  _get_rightpanel() {
           var iconclose=Icon(Icons.call_to_action, color:Colors.pink[100] );
           return new  Column(
             mainAxisAlignment:MainAxisAlignment.end,
             children: <Widget>[
               ElevatedButton.icon(onPressed: closeOrderdialog, icon: iconclose, label: new Text("\$"),
             style: ElevatedButton.styleFrom(
                 backgroundColor:Colors.blue[100],
                  shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
                 shadowColor: Colors.yellow
             )

    )]);

        }
void printorder() async{

   void onError(Exception error){
showMessage(error.toString(),Colors.red);  
   }
   ReestrModel title=ReestrModel.rows!.firstWhere((element) => element.id==widget.document_id);
  await CloseOrderModel.loadfromAPI(widget.document_id);
   String strcontents=CloseOrderModel.toXmlorder();
     StringBuffer stringBuffer=new StringBuffer();
       String xml="<DOCUMENT>\n";
     stringBuffer.write(xml);
xml="<TITLE><ROW>\n";
   stringBuffer.write(xml);
 xml="<NO>${title.no}</NO>\n";
 stringBuffer.write(xml);
xml="<PLACENAME>${title.place1}</PLACENAME>\n";
 stringBuffer.write(xml);
 xml="<MOLNAME>${Constants.garsonrow?.name}</MOLNAME>\n";
 stringBuffer.write(xml);
 xml="<DISCONTNAME>Надбавка за обслуживание</DISCONTNAME>\n";
 stringBuffer.write(xml);
 
xml="</ROW></TITLE>\n";
 stringBuffer.write(xml);
  stringBuffer.write(strcontents);
   xml="<TASK><ROW>\n";
   stringBuffer.write(xml);
  xml='<PIPE></PIPE>\n';
 stringBuffer.write(xml);
 xml="<TEMPLATE>order.xml</TEMPLATE>\n";
 stringBuffer.write(xml);
  xml="<PRINT>true</PRINT>\n";
 stringBuffer.write(xml);
   xml="</ROW></TASK>\n";
 stringBuffer.write(xml);
stringBuffer.write("</DOCUMENT>\n");
   
    String res=await  ApiRequest.apiSocket(stringBuffer.toString(),onError);
   if (res!=null) if (res is String ){ showMessage("Отправен счет на печать }");
   
   }
        
  
}
   Future<void> closeorder(int vari) async {
     String? dburl=Constants.dbendpoint;
              String url= '${dburl}/sqlexecute';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
  
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="document_id";
    paramitem["type"]=0;
    paramitem["v"]=widget.document_id;
    params.add(paramitem);

     paramitem=new Map<String,dynamic>();
      paramitem["name"]="vari";
    paramitem["type"]=0;
    paramitem["v"]=vari;
    params.add(paramitem);
     Map jsonMap={
        'sqlexec': 'closeorderAPI',
        'params':params,
       
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
        Map jsonres=json.decode(result);
        print(jsonres);
      int status=jsonres["id"];
      if(status==-1) showMessage(jsonres["status"],Colors.red);
      if(status==1){ await widget.cgbloc?.load();
       showMessage("Документ закрыт",Colors.blue);
       printorder();
      }
  } 
void closeOrderdialog(){
 Widget defbuttonButton = TextButton(
    child: Text("Закрываем обычно"),  
    onPressed: () {  
      Navigator.of(context).pop();  
      closeorder(0);
    },  
  );  
   Widget  nonDiscontoptionbutton = TextButton(
    child: Text("Закрываем без начислений"),  
    onPressed: () {  
      Navigator.of(context).pop(); 
       closeorder(1); 
    },  
  );  
   Widget cancelButton = TextButton(
    child: Text("Отмена"),  
    onPressed: () {  
      Navigator.of(context).pop();  
          },  
  );  

  AlertDialog alert = AlertDialog(  
    title: Text("Закрываем заказ"),  
    content: Text("Выберите опцию"),  
    actions: [  
      defbuttonButton,
      cancelButton,
      nonDiscontoptionbutton

    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}
Future<void> _updinAPI(double quantity, int increment) async {
ContentsModel? row=currentrow;
double q=row?.quantity.toDouble();
bool  flagdelete=false;
if(quantity==0) q=q+increment;
else q=quantity;
if(q<=0) flagdelete=true;

 String? dburl=Constants.dbendpoint;
              String url= '${dburl}/sqlexecute';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
  
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="goods_id";
    paramitem["type"]=0;
    paramitem["v"]=row?.goods_id;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="quantity";
    paramitem["type"]=0;
    paramitem["v"]=q;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="garson_id";
    paramitem["type"]=0;
    paramitem["v"]=Constants.garsonrow?.id;
    params.add(paramitem);

     paramitem=new Map<String,dynamic>();
      paramitem["name"]="vari";
    paramitem["type"]=0;
    paramitem["v"]=0;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="cont_id";
    paramitem["type"]=0;
    paramitem["v"]=row?.id;
    params.add(paramitem);

    paramitem=new Map<String,dynamic>();
      paramitem["name"]="seq";
    paramitem["type"]=0;
    paramitem["v"]=row?.seq;
    params.add(paramitem);

     Map jsonMap={
        'sqlexec': 'updinAPI',
        'params':params,
       
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
        Map jsonres=json.decode(result);
        print(jsonres);
      int status=jsonres["id"];
      if(status==-1) showMessage(jsonres["status"],Colors.red);
      if(status==1){ await widget.cgbloc?.load();
      if(flagdelete) {ctrltoContents.sink.add(-1);currentrow=null;}
      else  currentrow=ContentsModel.rows?.firstWhere((element) => element.id==row!.id,orElse: () => null as ContentsModel);
     
      }
    //  return result;


         }

void _updatecontents() async {
final result=await  Navigator.push(context,MaterialPageRoute(
    builder: (context) => UpdateContents(currentrow!,_updinAPI ))  );
         }


  Future<void> _updateprintmeet(int document_id, int barindex) async {
     String? dburl=Constants.dbendpoint;
              String url= '${dburl}/sqlexecute';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
  
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="document_id";
    paramitem["type"]=0;
    paramitem["v"]=widget.document_id;
    params.add(paramitem);
     Map jsonMap={
        'sqlexec': 'dcontentsmeta_b',
        'params':params,
       
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
        Map jsonres=json.decode(result);
        print(jsonres);
      int status=jsonres["id"];
      if(status==-1) showMessage(jsonres["status"],Colors.red);
      if(status==1){ await widget.cgbloc?.load();}
  }

 void sendpipe() {
   void onError(Exception error){
showMessage(error.toString(),Colors.red);  
   }
   print("reestrrow ContentsGui 361 ${ReestrModel.rows![0]}");
    ReestrModel title=ReestrModel.rows!.firstWhere((element) => element?.id==widget.document_id);
    Map<MesMeet,String>? mapmeet=ContentsModel.prepareToMeet();
    mapmeet?.forEach((key, value) async {
     StringBuffer stringBuffer=new StringBuffer();
       String xml="<DOCUMENT>\n";
     stringBuffer.write(xml);
xml="<TITLE><ROW>\n";
   stringBuffer.write(xml);
 xml="<NO>${title.no}</NO>\n";
 stringBuffer.write(xml);
xml="<PLACENAME>${title.place1}</PLACENAME>\n";
 stringBuffer.write(xml);
 xml="<MOLNAME>${Constants.garsonrow?.name}</MOLNAME>\n";
 stringBuffer.write(xml);
 xml="<CHECKTT></CHECKTT>\n";
 stringBuffer.write(xml);
  xml="<BARINDEXSTR>${key.barindexstr}</BARINDEXSTR>\n";
 stringBuffer.write(xml);
xml="</ROW></TITLE>\n";
 stringBuffer.write(xml);
  stringBuffer.write(value);
   xml="<TASK><ROW>\n";
   stringBuffer.write(xml);
  xml='<PIPE>${key.pipe}</PIPE>\n';
 stringBuffer.write(xml);
 xml="<TEMPLATE>meet.xml</TEMPLATE>\n";
 stringBuffer.write(xml);
  xml="<PRINT>true</PRINT>\n";
 stringBuffer.write(xml);
   xml="</ROW></TASK>\n";
 stringBuffer.write(xml);
stringBuffer.write("</DOCUMENT>\n");
   
    String res=await  ApiRequest.apiSocket(stringBuffer.toString(),onError);
   if (res!=null) if (res is String ){ showMessage("Отправлено на печать ${key.barindexstr}");
     _updateprintmeet(widget.document_id,key.barindex!);
     widget.seq++;
   }
        
            //if(res!="print") showMessage(res,Colors.red);
           
           }) ;
       }
     
       Widget       _get_buttonrule() {
        var iconplus=Icon(Icons.plus_one, color:Colors.white );
        
         var iconmodify=Icon(Icons.mode_edit, color:Colors.white );
         var iconnotify=Icon(Icons.notifications_active, color:Colors.white );
          var iconcomentr=Icon(Icons.comment, color:Colors.white );
         return new Container(
           //padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
           margin: EdgeInsets.fromLTRB(0, 0, 0, 15) ,
          // color:Colors.yellow,
           child: Row(children: <Widget>[
             ElevatedButton.icon(onPressed: (){
       _updinAPI(0,1);
     }, icon: iconplus, label: new Text("+"),
           style: ElevatedButton.styleFrom(
     shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
     shadowColor: Colors.yellow,
       backgroundColor: Colors.green)),
             ElevatedButton.icon(onPressed: (){
        _updinAPI(0,-1);
        }, icon: Image.asset("img/restoranblue.png"), label: new Text("-1"),
                 style: ElevatedButton.styleFrom(
                 shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
        splashFactory: InkSplash.splashFactory,
                     shadowColor: Colors.yellow,
          backgroundColor: Colors.red[400])),
             ElevatedButton.icon(onPressed: (){
           //updinAPI(0,1);
           _updatecontents();
        }, icon:iconmodify, label: new Text("Изменить"),
                 style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
        shadowColor: Colors.yellow)),
             ElevatedButton.icon(onPressed: sendpipe, icon:iconnotify, label: new Text("Оповещение"),
                 style: ElevatedButton.styleFrom(
           shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
             backgroundColor: Colors.pink[200],shadowColor: Colors.yellow)),
             ElevatedButton.icon(onPressed: (){}, icon:iconcomentr, label: new Text("Комментарий"),
                 style: ElevatedButton.styleFrom(
           shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
           shadowColor: Colors.yellow)),
               ],)
               );
           
             } 
           void  _CallBackRowContents(ContentsModel row){
           currentrow=row;
           print(currentrow);
           }
            Widget _get_body(){
                        return Row(
                       children: <Widget>[
                         Expanded(
                           flex: 3,
                           child: Container(
                             color: Colors.green,
                             child: new ContentsGoodsBlocGUI(widget.cgbloc as cisBloc, _CallBackRowContents,ctrltoContents)  //_get_reestr(),
                                       ),
                                     ),
                                     Expanded(
                                       flex: 7,
                                       child:Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex:1,
                                           child:_get_buttonrule()
                                                                            ),
                                                                             Expanded(
                                                                              flex:9,
                                                                           child:_buildSectionButton()
                                                                                                            ),
                                                                                                           Expanded(
                                                                                           flex: 1,
                                                                                           child: Container(
                                                                                             color: Colors.pink[300],
                                                                                             child: new BreadCrumbGUI(ctrl: ctrl,ctrltosevtion: ctrltoSection)
                                                                                                       ),
                                                                                                     )
                                                                                                          ]
                                                                                                        
                                                                                                       ),
                                                                                                       
                                                                                                     ),
                                                                                                     Expanded(
                                                                                           flex: 1,
                                                                                           child: Container(
                                                                                             color: Colors.green[100],
                                                                                             child: _get_rightpanel(),
                                                                                                       ),
                                                                                                     )
                                                                                                   ],
                                                                                                 );
                                                                                               
                                                                                                 }
                                                                             @override
                                                                             Widget build(BuildContext context) {
                                                                                return new Scaffold( key: _scaffoldKey,
                                                                                               appBar: PreferredSize(
                                                                                                 preferredSize: Size.fromHeight(30),
                                                                                                 child: AppBar(title: Text(widget.title),)),
                                                                                                  body: _get_body(),
                                                                                                  );
                                                                             }
                                                                           
                                           @override                              
                                            void dispose(){
                                             
                                              ctrl.close();
                                              ctrltoSection.close();
                                             super.dispose();
                                            }
     
     
      
       
                                   
                                  
   
    
}