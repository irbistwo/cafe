import 'dart:convert';
import 'dart:io';
import 'dart:math';
import "package:intl/intl.dart";

import "package:cafe/Constants.dart";
import 'package:cafe/utils/ApiRequest.dart';

class CloseOrderModel {
  static List<CloseOrderModel>? rows=null;
  int? id;
  int? document_id;
  String? goodsname;
  int? goods_id;
  String? sectionname;
  String? articul;
  int? section_id;
  String? packname;
  String? brendname;
  int? pack_id;
  dynamic? quantity;
  dynamic? summa;
  dynamic? price;
  dynamic? summadif;
  dynamic? summsellcost;
  String? cuuid;
  String? dataseq;
  int? intdataseq;
  String? kod;
  String? barcode;
  dynamic? capacity;
  dynamic? vaga;
  bool? is_servicefield;
  String? barindexstr;
  String? zonename;
  int? meta_doc_id;
  

  CloseOrderModel({this.id,this.document_id, this.goodsname,this.kod,this.barcode,this.articul, this.goods_id, this.sectionname,
      this.section_id, this.packname, this.pack_id, this.quantity,this.summa,
      this.price,this.summadif, this.cuuid, this.dataseq, this.intdataseq,this.capacity,this.vaga,this.summsellcost,this.brendname,this.is_servicefield=false,
      this.barindexstr,this.meta_doc_id,this.zonename});

  factory CloseOrderModel.fromMap(Map<String, dynamic> json) => new CloseOrderModel(
      goodsname: json["goodsname".toUpperCase()],
      price: json["price".toUpperCase()],
    summadif: json["SUMMADIFF"],
    summa: json["SUMMA"],
    barindexstr: json["BARINDEXSTR"],
    vaga:json["vaga".toUpperCase()],
    summsellcost:json["summsellcust".toUpperCase()],
    quantity:json["quantity".toUpperCase()],
    zonename: json["ZONENAME"],
    
    

  );

   String get prsellcostformated {
    if(price==null) return "0.00";
    final f = new NumberFormat("###,###,###.00","ru");
    final s = f.format(price);
    return s;
    //return summsellcost.toStringAsFixed(2);
  }

  String get quantityformated {
    if(quantity==null) return "0.00";
    if(quantity is int) return quantity.toString();
    final f = new NumberFormat("###,###,###.00","ru");
    final s = f.format(quantity);
    return s;
    //return summsellcost.toStringAsFixed(2);
  }

   String get summaformated {
    if(summsellcost==null) return "0.00";
    final f = new NumberFormat("###,###,###.00","ru");
    final s = f.format(summsellcost);
    return s;
    //return summsellcost.toStringAsFixed(2);
  }


    static Future<dynamic>? loadcontents(List<dynamic> res) {
      rows= res.isNotEmpty ? res.map((c) => CloseOrderModel.fromMap(c)).toList() : [];
    
  //  print(itemsall);
  }
  static loadfromAPI(int document_id) async {
      if(Constants.dbendpoint==null) {Constants.dbendpoint= await  Constants.get_sp("urldownloadjson");
   Constants.dbendpoint='http://${Constants.dbendpoint}';
    }
 String? dburl=Constants.dbendpoint;

       String url= '${dburl}/get_table';
    print("url="+url);
   List params=[];
   List empty=[];
   Map<String,dynamic>paramitem=new Map<String,dynamic>();
    paramitem["name"]="document_id";
    paramitem["type"]=0;
    paramitem["v"]=document_id;
    params.add(paramitem);
     Map jsonMap={
        'table': 'printcheckAPI',
        'params':params,
        'addwhere':empty,
        'setmacro':empty
       
      };
      String result=await ApiRequest.apiRequest(url,jsonMap);
   
  List jsonresult=json.decode(result);
  print(jsonresult);
    loadcontents(jsonresult);
  
    
  }
  Map<String, dynamic> toMap() => {
    "ID": id,
    "VAGA": vaga,
    "SECTIONNAME": sectionname,
    "BRENDNAME": brendname,
     "ZONENAME":zonename
   
  };

 

  
  
    static String toXmlorder(){
      StringBuffer stringBuffer=new StringBuffer();
      var contents=rows;
      String xml="<CONTENTS>\n";
      stringBuffer.write(xml);
      contents!.forEach((item){
        xml="<ROW>\n";
        stringBuffer.write(xml);
        xml="<GOODSNAME>${item.goodsname}</GOODSNAME>\n";
        stringBuffer.write(xml);
         
        xml="<BARINDEXSTR>${item.barindexstr}</BARINDEXSTR>\n";
        stringBuffer.write(xml);
        xml="<PRICE>${item.price}</PRICE>\n";
        stringBuffer.write(xml);
          xml="<SUMMADIFF>${item.summadif}</SUMMADIFF>\n";
        stringBuffer.write(xml);
        xml="<SUMMA>${item.summa}</SUMMA>\n";
        stringBuffer.write(xml);
       // xml="<HISTORYSTR>${item.historydata}</HISTORYSTR>\n";
       // stringBuffer.write(xml);
        xml="<GRSHEYKSTR></GRSHEYKSTR>\n";
        stringBuffer.write(xml);
        xml="<QUANTITY>${item.quantity}</QUANTITY>\n";
        stringBuffer.write(xml);
        xml="<SUMMSELLCUST>${item.summsellcost??''}</SUMMSELLCUST>\n";
        stringBuffer.write(xml);
       
        xml="</ROW>\n";
        stringBuffer.write(xml);
      });
      xml="</CONTENTS>\n";
      stringBuffer.write(xml);
  
      return stringBuffer.toString();
    }
  }
  
 
