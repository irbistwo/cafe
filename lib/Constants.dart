
import 'dart:async';
import 'dart:io';

import 'package:cafe/garson/GarsonModel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import "dart:math";

class Constants{
 static double? width;
 static double? height;
 static int pagecount=12;
 static  Directory? tempDir;
 static Directory? appDocDir;
 static bool _is_calc=false;
 static double fontsize=14;
 static double iconsize=40;
 static String sqlpack="select id,NAME as name from pack order by name";
 static String sqlsections="select id,NAME as name from section order by name";
 static String sqlfirms="select id,NAME as name from firms where is_produser=7 order by name";
 //тут хранятся настройки, наполняясь по мере требования
  static  Map<String,dynamic> _msp=new Map<String,dynamic>();
  //тут хранятся variable, наполняясь по мере требования
  static  Map<String,dynamic> _mspvar=new Map<String,dynamic>();

  static String? dbendpoint;

  static GarsonModel? garsonrow;

  static String? printurl;
  static init(BuildContext context){
if(!_is_calc) {
  width = MediaQuery.of(context).size.width;
  height = MediaQuery.of(context).size.height;

  var newpagecount = ((height! / 976) * pagecount).round();
  if (newpagecount != 0) {pagecount = newpagecount;
  if(width!<=320) {fontsize=9.8;iconsize=35;}
  if(height!<=534) pagecount=11;
  _is_calc=true;
  }

     Future<Directory> ftempDir =  getTemporaryDirectory();
     ftempDir.then((value) => tempDir=value);
      Future<Directory> fappDocDir =  getApplicationDocumentsDirectory();
     fappDocDir.then((value) => appDocDir=value);
  print("width=$width,height=$height,pagecount=$pagecount");
}

  }
  static IconData getByIndex(int index){
    IconData icon=Icons.filter_none;
    switch(index){
      case 0:icon=Icons.filter_1;break;
      case 1:icon=Icons.filter_2;break;
      case 2:icon=Icons.filter_3;break;
      case 3:icon=Icons.filter_4;break;
      case 4:icon=Icons.filter_5;break;
      case 5:icon=Icons.filter_6;break;
      case 6:icon=Icons.filter_7;break;
      case 7:icon=Icons.filter_8;break;
      case 8:icon=Icons.filter_9;break;
      case 9:icon=Icons.filter_9_plus;break;
      case 10:icon=Icons.filter_center_focus;break;
      case 11:icon=Icons.filter_b_and_w;break;
      case 12:icon=Icons.filter_drama;break;
      case 13:icon=Icons.filter_frames;break;
      case 14:icon=Icons.filter_hdr;break;
      case 15:icon=Icons.filter_none;break;
      case 16:icon=Icons.filter_list;break;
      case 17:icon=Icons.filter_tilt_shift;break;
      case 18:icon=Icons.cloud_done;break;
      case 19:icon=Icons.cloud_done;break;
      case 20:icon=Icons.cloud_done;break;


    }
    return icon;
  }
 static Future _futuregetsp(pref) async {
   return (await SharedPreferences.getInstance()).get(pref);

 }

 static Future<dynamic> get_sp(String pref) async{
 var completer = new Completer();
  dynamic res=_msp[pref];
  if(res==null){
   res = await _futuregetsp(pref);
   print("add new value for $pref=$res");
   _msp[pref]=res;
   completer.complete(res);
  }
  return completer.future;
   }

   static dynamic get_variable(String name){
     return _mspvar[name];
   }

   static void clear(){
    print("map constant is clear");
    _msp.clear();
   }
}