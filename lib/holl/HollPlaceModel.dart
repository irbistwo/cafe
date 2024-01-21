import 'dart:io';
import 'package:cafe/models/ModelInterface.dart';
import 'package:cafe/utils/ApiRequest.dart';
import '../Constants.dart';
import 'dart:convert';

import 'PlaceModel.dart';

class HollPlaceModel implements ModelInterface{
   static List<HollPlaceModel>? rows;
   String? dburl;
  int? id;
  String? xmltopology;
 PlaceModel? placemodel;
  HollPlaceModel({this.id,this.xmltopology}){
// Future databaseurl =Constants.get_sp("urldownloadjson");
//    databaseurl.then((url){ dburl = 'http://$url';});
  
  }
factory HollPlaceModel.fromMap(Map<String, dynamic> json) => new HollPlaceModel(
    id: json["HOLL_ID"],
    xmltopology: json["TOPOLOGY"]
   
   
  );
  static void resetTaped(){
    rows?.forEach((row) {
PlaceModel pl=row.placemodel!;
pl.rows?.forEach((rowpl) {
   rowpl.is_taped=false;
    rowpl.counttape=0;
    
    
    });

    });
  }
  static void _loadHollPlace(List res){
      rows= res.isNotEmpty ? res.map((c) => HollPlaceModel.fromMap(c)).toList() : [];
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

  static loadHoll() async {
    if(Constants.dbendpoint==null) {Constants.dbendpoint= await  Constants.get_sp("urldownloadjson");
   Constants.dbendpoint='http://${Constants.dbendpoint}';
    }
 String? dburl=Constants.dbendpoint;
  String appDocPath;
  String tempPath= Constants.tempDir!.path;
 /// appDocPath = Constants.appDocDir.path;
 
 // fbool.then(_handleValue);


  
  Future? _batirHoll() async {
   final file =File('$tempPath/holltopology.json');
    // Read the file.
    String contents = await file.readAsString();
    List jsonholl=json.decode(contents);
    _loadHollPlace(jsonholl);
  
  }
   Future<String> apiRequest() async {
       String url= '${dburl}/get_table';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
   List empty=[];
        Map jsonMap={
        'table': 'holltopology',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
  void _saveHoll(String contents,String filename){
      final file=File('$tempPath/holltopology.json');
      file.writeAsString(contents);
  
    }
  
    Future<void> _loadholl() async{
    String holl= await apiRequest();
      _saveHoll(holl,"holltopology.json");
    }
  
     var fbool=await File('$tempPath/holltopology.json').exists();
     if(!fbool) await _loadholl();
      await  _batirHoll();

  }
}