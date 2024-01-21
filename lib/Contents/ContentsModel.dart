import 'dart:convert';
import 'dart:io';
import 'dart:math';
import "package:intl/intl.dart";

import "package:cafe/Constants.dart";
import 'package:cafe/utils/ApiRequest.dart';

class ContentsModel {
  static List<ContentsModel>? rows;
   static List<ContentsModel> rowstogui=[];
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
  dynamic? quantityclosed;
  dynamic? prsellcost;
  dynamic? prsellcostbefore;
  dynamic? summsellcost;
  String? cuuid;
  String? dataseq;
  int? intdataseq;
  String? kod;
  String? barcode;
  dynamic? capacity;
  dynamic? vaga;
  bool? is_servicefield;
  int? seq;
  int? barindex;
  String? zonename;
  int? meta_doc_id;
  String? historydata;
  String? lastprintdata;
  int? countprint;
  String? seqdata;
  String? event;
  String? comentr;

  ContentsModel({this.id,this.document_id, this.goodsname,this.kod,this.barcode,this.articul, this.goods_id, this.sectionname,
      this.section_id, this.packname, this.pack_id, this.quantity,this.quantityclosed,
      this.prsellcost,this.prsellcostbefore, this.cuuid, this.dataseq, this.intdataseq,this.capacity,this.vaga,this.summsellcost,this.brendname,this.is_servicefield=false,
      this.barindex,this.historydata,this.lastprintdata,this.meta_doc_id,this.seq,this.zonename,this.countprint,this.seqdata,this.event,this.comentr});

  factory ContentsModel.fromMap(Map<String, dynamic> json) => new ContentsModel(
      id: json["id".toUpperCase()],
    document_id: json["document_id".toUpperCase()],
      goodsname: json["goodsname".toUpperCase()],
    articul: json["articul".toUpperCase()],
    kod: json["kod".toUpperCase()],
    barcode: json["barcode".toUpperCase()],
      goods_id: json["goods_id".toUpperCase()],
      sectionname: json["sectionname".toUpperCase()],
      section_id: json["section_id".toUpperCase()] ,
     packname: json["packname".toUpperCase()] ,
      pack_id:json["pack_id".toUpperCase()],
      prsellcost: json["prsellcost".toUpperCase()],
    prsellcostbefore: json["prsellcostbefore"],
    seq: json["seq".toUpperCase()] ,
    historydata :json["HISTDATA"],
    lastprintdata :json["LASTPRINTDATA"],
    barindex: json["BARINDEX"],
    countprint: json["COUNTPRINT"],
    meta_doc_id: json["META_DOC_ID"],
    vaga:json["vaga".toUpperCase()],
    summsellcost:json["summsellcust".toUpperCase()],
    quantity:json["quantity".toUpperCase()],
    brendname: json["brendname"],
    zonename: json["ZONENAME"],
    seqdata:  json["SEQDATA"],
    event:json["EVENT"],
    comentr: json["COMENTR"]
    

  );

   String get prsellcostformated {
    if(prsellcost==null) return "0.00";
    final f = new NumberFormat("###,###,###.00","ru");
    final s = f.format(prsellcost);
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

static int get_seq(){
  if(rows!.length==0) return 0;
  Set<int> sseq=new  Set<int>();
  rows?.forEach((row) {sseq.add(row.seq!); });
  int seq=sseq.toList().reduce(max);
  print('seq=$seq');
  return seq;

}
    static Future? loadcontents(List res) {
      rows= res.isNotEmpty ? res.map((c) => ContentsModel.fromMap(c)).toList() : [];
    if(rows!.length>0)  rowstogui=_buildlist("SEQDATA", rows!);
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
        'table': 'dcontentsmeta_p',
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
    "SEQ":seq,
    "ZONENAME":zonename,
    "BARINDEX":barindex,
     "SEQDATA":seqdata
  };

 static List<ContentsModel> _buildlist(String name,List<ContentsModel> list){
    List<ContentsModel> resultlist=[];
    ContentsModel cm=list[0];
    Map <String,dynamic> map=cm.toMap();
    dynamic value=map[name];
    var cmlist=new ContentsModel(goodsname: value.toString(),is_servicefield: true);
    if(cmlist.goodsname=="null") cmlist.goodsname="Не определено";
    resultlist.add(cmlist);
     list.forEach((item){
      map=item.toMap();
      if(map[name]!=value){
        value=map[name];
        cmlist=new ContentsModel(goodsname: value.toString(),is_servicefield: true);
        resultlist.add(cmlist);
        resultlist.add(item);
      }
      else resultlist.add(item);
    });
    //dynamic value=cm.;
return resultlist;
  }

  static Map<MesMeet,String>? prepareToMeet(){
  Map<MesMeet,String> result=new Map<MesMeet,String>();
  var notprintrows=rows?.where((row) => ((row.countprint??0)==0));
  if(notprintrows?.length==0) return null;
  Set<String> pipeset=new Set<String>();
  notprintrows?.forEach((element) {pipeset.add(element.event!);});
  pipeset.forEach((pipe) { 
  var pipemeet=notprintrows?.where((row) => row.event==pipe);
  String xmlpipe=toXmlmeet(pipemeet!);
  MesMeet mpipe=new MesMeet(pipe:pipe,barindex: pipemeet.toList()[0].barindex!);
  result[mpipe]=xmlpipe;
  });
  return result;
    }
  
    static String toXmlmeet(Iterable<ContentsModel> pipemeet){
      StringBuffer stringBuffer=new StringBuffer();
      var contents=pipemeet;
      String xml="<CONTENTS>\n";
      stringBuffer.write(xml);
      contents.forEach((item){
        xml="<ROW>\n";
        stringBuffer.write(xml);
        xml="<GOODSNAME>${item.goodsname}</GOODSNAME>\n";
        stringBuffer.write(xml);
        xml="<COMENTR>${item.comentr}</COMENTR>\n";
        stringBuffer.write(xml);
        xml="<SEQ>${item.seq}</SEQ>\n";
        stringBuffer.write(xml);
          xml="<COUNTPRINT>${item.countprint}</COUNTPRINT>\n";
        stringBuffer.write(xml);
        xml="<HISTORYSTR>${item.historydata}</HISTORYSTR>\n";
        stringBuffer.write(xml);
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
  
  class MesMeet {
    final int? barindex;
     final String? pipe;
     String get barindexstr {
switch (barindex){
  case 1:return 'Кухня';
  case 2:return 'Бар';
  case 3:return 'Кухня2';
  case 4:return 'Бар2';
  default: return 'Точка производства';
}
    }
   

  MesMeet({this.barindex, this.pipe});
}