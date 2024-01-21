library xml_flut;
import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'package:cafe/sp/SPcis.dart';


class ParseXmlHoll extends Object {
  Map <String,Map<SpDescribe,dynamic>> msp={};
  List<String> iconlist=[];
  //final maintag/*="document"*/;
  final tag="holl";
  final String? xmlstr;
   String? colorholl;
   String? widthholl;
   String? heightholl;
   List<Map<String,dynamic>> result=<Map<String,dynamic>>[];
  ParseXmlHoll({this.xmlstr}) {

    final document = xml.XmlDocument.parse(xmlstr!);
    final elements = document.findAllElements(tag);
     print(xmlstr);

    elements.forEach((node) {
      this.colorholl= node.getAttribute("color");
      this.widthholl = node.getAttribute("width");
      this.heightholl = node.getAttribute("height");
       _set_resultmap(node,"place");
       _set_resultmap(node,"roundplace");
       _set_resultmap(node,"panel");
       _set_resultmap(node,"label");
                     
          });
      
      
      
         
        }
      
 void _set_resultmap(xml.XmlElement node, String type) {
 final items = node.findElements(type);
            items.forEach((node) {
              Map<String,dynamic> map=new Map<String,dynamic>();
              //  print(node.getAttribute("name"));
               map["TYPE"]= type;
               map["COLOR"]= node.getAttribute("color");
              map["WIDTH"] = node.getAttribute("width");
              map["HEIGHT"] = node.getAttribute("height");
              map["TOP"] = node.getAttribute("y");
              map["LEFT"] = node.getAttribute("x");  

             map["TAG"]= node.getAttribute("tag")??"0";
              map["ICON"]= node.getAttribute("icon");
               map["TEXT"]= node.getAttribute("text");
            // print(map.toString());
            result.add(map);
            });
        }


}