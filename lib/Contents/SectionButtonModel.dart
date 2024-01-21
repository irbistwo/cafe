import 'dart:convert';
import 'dart:io';

import "package:cafe/Constants.dart";
import 'package:cafe/utils/ApiRequest.dart';

class SectionButtonModel {
  static String filejson="section.json";
  static List<SectionButtonModel>? items;
  static List<SectionButtonModel>? itemsall;
  static List<SectionButtonModel>? itemsgoods;
  int? id;
  int? parent_id;
  int? section_id;
  int? iamgoods=0;
  String? sectionname;
  dynamic? quantity;
  dynamic? prsellcost;
  int? producer_id;
  String? brendname;
  dynamic? vaga;
  dynamic? capacity;
  String? barcode;
  String? kod;
  int? pack_id;
  String? packname;
  int? page;
 // int itemonscrreen=5;
  static int pagecount=Constants.pagecount+8;


  SectionButtonModel({this.id, this.parent_id, this.iamgoods, this.sectionname,
      this.quantity, this.prsellcost,this.producer_id, this.brendname, this.vaga, this.capacity,
  this.barcode,this.kod,this.pack_id,this.packname,this.section_id});


  factory SectionButtonModel.fromMap(Map<String, dynamic> json) => new SectionButtonModel(
    id: json["id".toUpperCase()],

    //articul: json["articul"],
    kod: json["kod"],
    barcode: json["barcode"],
    parent_id: json["refere_id".toUpperCase()],
    sectionname: json["name".toUpperCase()],
    section_id: json["section_id".toUpperCase()] 
    
   
   // iamgoods: json["iamgoods"]

  );

  factory SectionButtonModel.fromMapgoods(Map<String, dynamic> json) => new SectionButtonModel(
    id: json["id".toUpperCase()],

    //articul: json["articul"],
    kod: json["kod"],
    barcode: json["barcode"],
    parent_id: json["refere_id".toUpperCase()],
    sectionname: json["name".toUpperCase()],
    section_id: json["section_id".toUpperCase()] ,
    packname: json["packname"] ,
    pack_id:json["pack_id"],
    prsellcost: json["prsellcost"],
    vaga:json["vaga"],
    quantity:json["quantity"],
    iamgoods: 1

  );
  static Future? loadsection(List res) {
      itemsall= res.isNotEmpty ? res.map((c) => SectionButtonModel.fromMap(c)).toList() : [];
    items=getMainmenu(itemsall!);
  //  print(itemsall);
  }
  

   static Future? loadgoods(List res) {
      itemsgoods= res.isNotEmpty ? res.map((c) => SectionButtonModel.fromMapgoods(c)).toList() : [];
   // items=getMainmenu(itemsall);
  //  print(itemsall);
  }

  

  static List<SectionButtonModel> getMainmenu(List<SectionButtonModel> items){
    var newlist= items.where((item)=>(item.parent_id??0)==0);
     return newlist.toList();
  }

  static List<SectionButtonModel> getGoods(int section_id){
    var newlist= itemsgoods!.where((item)=>item.section_id==section_id);
     return newlist.toList();
  }

  static List<SectionButtonModel> getParentmenu(List<SectionButtonModel> items,parent_id){
    var newlist= items.where((item)=>item.parent_id==parent_id);
    return newlist.toList();
  }

static List<SectionButtonModel>  get_breadcrumbarray(List<SectionButtonModel> items,parent_id){
    if (parent_id==0 ) return [];
    List<SectionButtonModel> result=<SectionButtonModel>[];
    var row=getHiertmenu(items,parent_id);
    while(row!=null){
      result.add(row);
       row=getHiertmenu(items,row.parent_id);
    }
    return result;
  }
  static SectionButtonModel? getHiertmenu(List<SectionButtonModel> items,parent_id){
    if (parent_id==0 ) return null;
    try{
    SectionButtonModel newlist= items.firstWhere((item)=>item.id==parent_id);
    return newlist;
    }catch(e){}
    return null;
  }

  static List<SectionButtonModel> getPage(int page){
    List<SectionButtonModel> itemsnew=[];
    if(page!=0){
      itemsnew.add(new SectionButtonModel(id: -1,sectionname: "Назад"));
    }
    int i=page*pagecount;
    int j=(page+1)*pagecount;
    bool endpage=false;
    if(j>items!.length) {j=items!.length;

    }
   // print("one=${items.length},two=${(page+1)*pagecount}");
    if(items!.length<=((page+1)*pagecount)) endpage=true;
   // i--;
   // j--;

    for (int k=i;k<j;k++) {
      itemsnew.add(items![k]);}
    if(!endpage)  itemsnew.add(new SectionButtonModel(id: -2,sectionname: "Далее"));
    return itemsnew;
  }

  static void dividebypage(){
    int i=0;
    List<SectionButtonModel> itemsnew=<SectionButtonModel>[];
  //  itemsnew.
    items!.forEach((item){
      itemsnew.add(item);
      i++;
    });
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


  
  Future<void> _batir() async {
   final file =File('$tempPath/$filejson');
    // Read the file.
    String contents = await file.readAsString();
    List jsonresult=json.decode(contents);
    loadsection(jsonresult);
  
  }
   Future<String> apiRequest() async {
       String url= '${dburl}/get_table';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
   List empty=[];
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
    paramitem["name"]="sectiontreetype_id";
    paramitem["type"]=0;
    paramitem["v"]=Constants.garsonrow?.sectiontreetype_id;
    params.add(paramitem);
     Map jsonMap={
        'table': 'dsectiontree',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
  void _savejsonFile(String contents,String filename){
      final file=File('$tempPath/$filejson');
      file.writeAsString(contents);
  
    }
  
    Future<void> _loadfrombase() async{
    String json= await apiRequest();
    print(json);
    _savejsonFile(json,filejson);
    }
  
     var fbool=await File('$tempPath/$filejson').exists();
     if(!fbool) await _loadfrombase();
      await _batir();
     // print(items.length);
     //  print(itemsall.length);

  }

  static loadfromAPIgoods() async {
    String filejson="goods.json";
      if(Constants.dbendpoint==null) {Constants.dbendpoint= await  Constants.get_sp("urldownloadjson");
   Constants.dbendpoint='http://${Constants.dbendpoint}';
    }
 String? dburl=Constants.dbendpoint;
  String appDocPath;
  String tempPath= Constants.tempDir!.path;
 /// appDocPath = Constants.appDocDir.path;
 
 // fbool.then(_handleValue);


  
  Future<void> _batir() async {
   final file =File('$tempPath/$filejson');
    // Read the file.
    String contents = await file.readAsString();
   print("contents=$contents,filepath=$tempPath/$filejson");
    List jsonresult=json.decode(contents);
    loadgoods(jsonresult);
  
  }
   Future<String> apiRequest() async {
       String url= '${dburl}/get_table';
   //String url= '${widget.dburl}/prro';
   print("url="+url);
   List params=[];
   List empty=[];
  
     Map jsonMap={
        'table': 'dgoodstree_p',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
      return result;

   }
  
  void _savejsonFile(String contents,String filename){
      final file=File('$tempPath/$filejson');
      file.writeAsString(contents);
  
    }
  
    Future<void> _loadfrombase() async{
    String json= await apiRequest();
    print(json);
    _savejsonFile(json,filejson);
    }
  
     var fbool=false;//await File('$tempPath/$filejson').exists();
     if(!fbool) await _loadfrombase();
      await _batir();
      print(itemsgoods?.length);
     //  print(itemsall.length);

  }
  @override
  String toString(){
return '$id,$sectionname,$section_id';
  }

}