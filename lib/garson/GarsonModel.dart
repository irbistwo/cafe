import 'dart:io';
import 'package:cafe/models/ModelInterface.dart';
import 'package:cafe/utils/ApiRequest.dart';
import '../Constants.dart';
import 'dart:convert';

class GarsonModel implements ModelInterface{
   static List<GarsonModel>? rows;
   String? dburl;

  int? id;
  String? name;

  int? is_admin;
  int? sectiontreetype_id;

  String? pocketcode;
  GarsonModel({this.id,this.name, this.is_admin, this.pocketcode,this.sectiontreetype_id}){
 Future databaseurl =Constants.get_sp("urldownloadjson");
    databaseurl.then((url){ dburl = 'http://$url';});
  
  }
factory GarsonModel.fromMap(Map<String, dynamic> json) => new GarsonModel(
    id: json["FIRMS_ID"],
    name: json["NAME"],
    is_admin: json["IS_ADMIN"]??0,
    pocketcode:json["POCKETCODE"],
    sectiontreetype_id:json["sectiontreetype_id".toUpperCase()]
   
   
  );
  static void loadGarson(List res){
      rows= res.isNotEmpty ? res.map((c) => GarsonModel.fromMap(c)).toList() : [];
  }

  @override
  // TODO: implement list
  List get list => rows!;

  @override
  Future? load({String filter = "", String? orderby}) {
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
   List empty=[];
  
     Map jsonMap={
        'table': 'dofficiant',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
    
     String contents= await  apiRequest();
     print(contents);
      List jsonholl=json.decode(contents);
      loadGarson(jsonholl);

  }
}