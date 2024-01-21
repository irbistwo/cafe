import 'dart:convert';

import 'package:cafe/models/ModelInterface.dart';
import 'package:cafe/utils/ApiRequest.dart';
import "package:intl/intl.dart";

import '../Constants.dart';
class ReestrModel  implements ModelInterface {
  static List<ReestrModel>? rows;
  int? id;
  String? firmsname;
  int? firms_id;
  String? databook;
  int? intdatabook;
  int? no;
  int? firmsomol_id;
  String? statusstr;
  int? is_check;
  dynamic? summsellcost;
  String? d1;
  String? d2;
  String? place1;
  String? lastgoods;
  String? longtitude;
  int? place_id;

  ReestrModel({
    this.id,
    this.firmsname,
    this.firms_id,
    this.databook,
    this.intdatabook,
    this.no,
    this.firmsomol_id,
    this.is_check,
    this.statusstr,
    this.summsellcost,
    this.place1,
    this.lastgoods,
    this.longtitude,
    this.place_id
  });

  DateTime get datacalendar{
    var listdata = databook?.split(".");
    try {
      var dd = listdata?[0];
      var mm = listdata?[1];
      var yyyy = listdata?[2];
      var day = int.parse(dd!);
      var months = int.parse(mm!);
      var year = int.parse(yyyy!);
      var d = DateTime.utc(year, months, day);
      return d;
    }catch(e){
      print("trouble parse data $databook");
      return new DateTime.now().add(new Duration(days: 2));
    }
  }

  String get summaformated {
    if(summsellcost==null) return "0.00";
    final f = new NumberFormat("###,###,###.00","ru");
    final s = f.format(summsellcost);
    return s;
    //return summsellcost.toStringAsFixed(2);
  }

   static void loadReestr(List res){
      rows= res.isNotEmpty ? res.map((c) =>ReestrModel.fromMap(c)).toList() : [];
  }

  factory ReestrModel.fromMap(Map<String, dynamic> json) => new ReestrModel(
    id: json["id".toUpperCase()],
    firmsname: json["firmsname".toUpperCase()],
    firms_id: json["firms_id".toUpperCase()],
    firmsomol_id: json["FIRMSOMOL_ID"],
    databook: json["databookstr".toUpperCase()] ,
    intdatabook: json["intdatabook"] ,
    no: json["no".toUpperCase()] ,
    is_check:json["IS_CHECK"],
    statusstr: json["statusstr"],
    summsellcost: json["summasell".toUpperCase()],
    place1: json["PLACE1"],
    longtitude:json["longtitude"],
    lastgoods: json["LASTGOODS"],
    place_id:json["PLACE_ID"]
  );

  @override
  // TODO: implement list
  List get list => rows!;

  @override
  Future? load({String filter = "",  String? orderby}) {
   return null;
  }

  @override
  Map<String, dynamic>? toMap() {
    return null;
  }

  static loadfromAPI() async {
      if(Constants.dbendpoint==null) {Constants.dbendpoint= await  Constants.get_sp("urldownloadjson");
   Constants.dbendpoint='http://${Constants.dbendpoint}';
    }
 String? dburl=Constants.dbendpoint;
  String appDocPath;
  String tempPath= Constants.tempDir!.path;
 /// appDocPath = Constants.appDocDir.path;
 
 // fbool.then(_handleValue);


  

   Future<String> apiRequest() async {
       String url= '${dburl}/get_table';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
   List addwhere=[];
   List setmacro=[];
  
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
   /* paramitem["name"]="d1";
    paramitem["type"]=4;
    paramitem["v"]="value";
    params.add(paramitem);
      paramitem=new Map<String,dynamic>();
      paramitem["name"]="d2";
    paramitem["type"]=4;
    paramitem["v"]=10;
    params.add(paramitem);
*/
     paramitem=new Map<String,dynamic>();
      paramitem["name"]="doc_type";
    paramitem["type"]=0;
    paramitem["v"]=5;
    params.add(paramitem);

     paramitem=new Map<String,dynamic>();
     paramitem["v"]="databook between trunc(sysdate)-2 and trunc(sysdate) ";
     addwhere.add(paramitem);
     Map jsonMap={
        'table': 'dreestrdocmetanet',
        'params':params,
        'addwhere':addwhere,
        'setmacro':setmacro
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
    
     String contents= await  apiRequest();
     print(contents);
      List jsonholl=json.decode(contents);
      loadReestr(jsonholl);

  }

  
}