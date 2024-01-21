import 'dart:convert';

import 'package:cafe/Contents/ContentsGUI.dart';
import 'package:cafe/Contents/ContentsGoodsBloc.dart';
import 'package:cafe/Contents/SectionButtonModel.dart';
import 'package:cafe/Reestr/ReestrBlocGUI.dart';
import 'package:cafe/Reestr/ReestrBlock.dart';
import 'package:cafe/Reestr/ReestrModel.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:cafe/utils/ApiRequest.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'HollButton_blockGUI.dart';
import 'HollPlaceBloc.dart';
import 'HollPlaceModel.dart';
import 'PlaceModel.dart';
import 'hollButtonBlock.dart';

class Holl extends StatefulWidget {
  String? dburl;
   String? tempPath;
  String? appDocPath;
  final hollbuttonblockBloc? buttonholbloc;
  final  HollPlaceBloc? hpbloc;
  final ReestrBloc? reestrbloc;

  int? initholl_id;
  
  Holl({this.buttonholbloc,this.hpbloc, this.initholl_id, this.reestrbloc}) {
    /*
 Future databaseurl =Constants.get_sp("urldownloadjson");
    databaseurl.then((url){ dburl = 'http://$url';
    Constants.dbendpoint=dburl;
//initState();
    });
*/
  }

   @override
  _HollGUIState createState() => _HollGUIState();

    
  }
  
  class _HollGUIState extends State<Holl> {

  int value = -1;
  Color color=Color.fromARGB(89, 0, 67, 6);
  int? hollindex;
 @override
 void  initState()  {
    hollindex=widget.initholl_id;
    }

   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
     void showMessage(String message, [MaterialColor color = Colors.green]) {

       ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
          new SnackBar(backgroundColor: color, content: new Text(message)));
  
    }

     Widget _builHoll() {
 HollPlaceBloc? bloc=widget.hpbloc;
//bloc.load();

  return StreamBuilder<List>(
      stream: bloc?.streamlist,
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
      List<HollPlaceModel>? listfiltered=results.cast<HollPlaceModel>();
int i=-1;
try{
   var row=listfiltered?.firstWhere((item) => item.id==hollindex);
   if(row!=null) i=listfiltered!.indexOf(row);
   } catch(e){}

        if(i==-1) return new Container();
        return _get_holl(listfiltered![i].placemodel!);
      },
    );


     }

     Color? hexToColor(String code) {
       Color? color=Colors.blue[300];
       if(code==null) return color;
       try {
         color= new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
       } on Exception catch (e) {
               print(code);
       }
  return color;
}
List<Widget> _get_placement(PlaceModel placeModel){
   List<PlaceModel>? rows=placeModel.rows;
   List<Widget> result=<Widget>[];
rows?.forEach((row) {
String aseetpathimg="img/19.png";
if(row.is_busy!) aseetpathimg="img/42.png";
if(!row.is_taped!) if(row.is_owned!) {row.color="#ffff176";
}
if(row.is_owned!) aseetpathimg="img/44.png";
if(row.counttape==2) {aseetpathimg="img/plus.png";row.color="#ffffD00";}
Positioned widget0=new Positioned(
  
         top:row.top?.toDouble(),
         left: row.left?.toDouble(),
          width: row.width?.toDouble(),
          height: row.height?.toDouble(),
          child:   new GestureDetector(
        onTap: () async {
       if(!(row.type=="place"||row.type=="roundplace")) return;
          print("Container clicked ${row.text}");
      row.color="#ccccff";
    //  bool is_tapedlater=row.is_taped;
      row.is_taped=!row.is_taped!;
      List<ReestrModel> listresult=widget.reestrbloc!.filterGarsonandPlace(row.id!);
      row.counttape++;
          if(row.counttape>=3+listresult.length) {row.counttape=0;
         // if(is_tapedlater) 
       int id=  await _addNewDoc(row);
             if(id!=-1)      _ShowContents(row,id);
               HollPlaceModel.resetTaped();
                   }
                                      setState(() {
                       
                     });
                    // widget.hpbloc.refresh();
                         },
                          child:
                          Container(child: new Text(row.text??"", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                         width: row.width?.toDouble(),
                         height: row.height?.toDouble(),
                           //color: hexToColor(row.color),
                            decoration:new BoxDecoration(
                          image: (row.type=="place"||row.type=="roundplace") ?new DecorationImage(image:AssetImage(aseetpathimg),fit:BoxFit.scaleDown):null,   
                       color: hexToColor(row.color!),
                       shape: (row.type=="place"||row.type=="roundplace")? BoxShape.circle:BoxShape.rectangle,
                     ),
                           //child: ,
                         //child: const Center(child: Text('Entry A')),
                       )
                         )
                       
                 
                 );
               result.add(widget0);
                });
                return result;
                   } 
               
                     Widget _get_holl(PlaceModel placeModel){
                       return new SingleChildScrollView(
                   scrollDirection :Axis.horizontal,
                            child:SizedBox( width: placeModel.holl_width?.toDouble(),
                             height: double.infinity,
                             child: 
                             Container(
                                color: hexToColor(placeModel.holl_color!),
                             child:Stack(
                            //overflow: Overflow.clip,  
                     children:_get_placement(placeModel),
                  
                 
                   ),
                                   )
                                          )    
                 );
                 
               
                     }
               void _set_hollindex(int index){
               setState(() {
                  hollindex=index;
               });
               }
               
                  Widget   _get_reestr() {
                return new  Container(
                         //  color:  Colors.gr,
                         child: new ReestrBlocGUI(widget.reestrbloc as cisBloc,_set_hollindex)//_buttonHoll
                         
                         );
                  }
                  
                 Widget _get_buttonholl(){
                  int index=widget.buttonholbloc!.get_index(widget.initholl_id!);
                  return new  Container(
                           color:  Colors.yellow,
                         child: new HollButton_blockGui(widget.buttonholbloc!,index,_set_hollindex)//_buttonHoll
                         
                         );
                 
                 }
                 
                   Widget _get_body(){
                      return Row(
                     children: <Widget>[
                       Expanded(
                         flex: 2,
                         child: Container(
                           color: Colors.green,
                           child: _get_reestr(),
                                     ),
                                   ),
                                   Expanded(
                                     flex: 8,
                                     child:Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex:1,
                                         child:_get_buttonholl()
                                          ),
                                           Expanded(
                                            flex:9,
                                         child:_builHoll()
                                          )
                             
                                        ]
                                      
                                     ),
                                   ),
                                 ],
                               );
                             
                               }
                              
               
Future<void> _ShowContents(PlaceModel row,int document_id) async {
                    ContentsGoodsBloc cgbloc=new ContentsGoodsBloc(document_id:document_id );
                      cgbloc.load();
                    SectionButtonModel.loadfromAPIgoods();
                 await  SectionButtonModel.loadfromAPI();
                  ReestrModel.loadfromAPI();    
         ContentsGUI contents=new ContentsGUI(seq:1,document_id:document_id,cgbloc:cgbloc,title: "Новый заказ столика ${row.text} ${Constants.garsonrow!.name}",);
            await       Navigator.push(
           context,
           MaterialPageRoute(
           builder: (context) => contents,
                            ),
                    );
                await    widget.reestrbloc?.load();
                widget.hpbloc?.rows=ReestrModel.rows!;
                await widget.hpbloc?.load();
                 setState(() {
                    
                  });
                                 /*
                  await widget.hpbloc.load();
                  setState(() {
                    
                  });
                  */
                 }
  Future<int> _addNewDoc(PlaceModel row) async{
               String? dburl=Constants.dbendpoint;
              String url= '${dburl}/sqlexecute';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
  
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="place_id";
    paramitem["type"]=0;
    paramitem["v"]=row.id;
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
      paramitem["name"]="oid";
    paramitem["type"]=0;
    paramitem["v"]=0;
    params.add(paramitem);

     Map jsonMap={
        'sqlexec': 'addDocAPI',
        'params':params,
       
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
        Map jsonres=json.decode(result);
        print(jsonres);
      int id=jsonres["id"];
      if(id==-1) showMessage(jsonres["status"],Colors.red);
    //  return result;
    
return id;

          }            
           
   @override
 Widget build(BuildContext context) {
   return new Scaffold( key: _scaffoldKey,
  appBar: PreferredSize(
  preferredSize: Size.fromHeight(10),
  child: AppBar()),
  body: _get_body(),
  );
                               }
  
  }