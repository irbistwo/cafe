import 'dart:io';
import 'package:cafe/models/ModelInterface.dart';
import 'package:cafe/utils/ApiRequest.dart';
import '../Constants.dart';
import 'dart:convert';

class HollButtonModel implements ModelInterface{
   static List<HollButtonModel>? rows;
   String? dburl;

  int? id;
  String? name;
  HollButtonModel({this.id,this.name}){
 Future databaseurl =Constants.get_sp("urldownloadjson");
    databaseurl.then((url){ dburl = 'http://$url';});
  
  }
factory HollButtonModel.fromMap(Map<String, dynamic> json) => new HollButtonModel(
    id: json["ID"],
    name: json["NAME"]
   
   
  );
  static void loadHollButton(List res){
      rows= res.isNotEmpty ? res.map((c) => HollButtonModel.fromMap(c)).toList() : [];
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



      Future _batirHoll() async {
   final file =File('$tempPath/holl.json');
    // Read the file.
    String contents = await file.readAsString();
    List jsonholl=json.decode(contents);
    loadHollButton(jsonholl);
  
  }
   Future<String> apiRequest() async {
       String url= '${dburl}/get_table';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
   List empty=[];
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
    paramitem["name"]="paramname";
    paramitem["type"]=2;
    paramitem["v"]="value";
    params.add(paramitem);
      paramitem=new Map<String,dynamic>();
      paramitem["name"]="paramname2";
    paramitem["type"]=1;
    paramitem["v"]=10;
    params.add(paramitem);
     Map jsonMap={
        'table': 'dbasicholl',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
  void _saveHoll(String contents,String filename){
      final file=File('$tempPath/holl.json');
      file.writeAsString(contents);
  
    }
  
    Future<void> _loadholl() async{
    String holl= await apiRequest();
      _saveHoll(holl,"holl.json");
    }
  
     var fbool=await File('$tempPath/holl.json').exists();
     if(!fbool) await _loadholl();
      await  _batirHoll();

  }
}