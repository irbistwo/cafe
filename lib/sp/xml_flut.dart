library xml_flut;
import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'package:cafe/sp/SPcis.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class XmlDesc extends Object {
  Map <String,Map<SpDescribe,dynamic>> msp={};
  List<String> iconlist=[];
  final maintag/*="document"*/;
  final tag/*="title"*/;
  //List<String> arguments = ["-t", "title", "bin/books.xml"];
  //final files = <File>[];
  XmlDesc({this.maintag,this.tag}) {

    //final file = File("bin/flut.xml");
    Future<String> xmlstr=loadXml();
    xmlstr.then((result){
    final document = xml.XmlDocument.parse(result);
    final elements = document.findAllElements(tag);
    // print(result);

    elements.forEach((node) {
      String? titlename = node.getAttribute("name");
      String? iconname = node.getAttribute("icon");
      iconname=iconname ?? "img/settings.png";
      //print("iconname $iconname");
      iconlist.add(iconname);

      Map<SpDescribe, dynamic> map = new Map<SpDescribe, dynamic>();
      final items = node.findElements("item");
      items.forEach((node) {
        //  print(node.getAttribute("name"));
        Type t = String;
        dynamic d = node.getAttribute("initvalue");
        switch (node.getAttribute("type")) {
          case "boolean":
            t = bool;
            d = (node.getAttribute("initvalue") == "true");
            break;
          case "List":
            t = List;
            d = (node.getAttribute("initvalue"));
            d = int.parse(d);
            break;
        }
        String? uiname = node.getAttribute("uiname");
        var listuiname = uiname?.split(";");
        //  print(listuiname);
        int inticon=0xe8b9;
        try {
          inticon = int.parse(node.getAttribute("icon")!);
        } catch(e){
          print(e);
        }
        SpDescribe spDescribe = new SpDescribe(
            name: node.getAttribute("name")!, type: t, uiname: listuiname!,
            icon: inticon);
        map[spDescribe] = d;
      });
      msp[titlename!] = map;
    });



    });
  }

  Future<String> loadXml() async {
    return await rootBundle.loadString('xmlsp/flutsp.xml');
  }

}