
import 'package:cafe/models/ModelInterface.dart';


class PlaceModel implements ModelInterface{
    List<PlaceModel>? rows;
   String? dburl;
  int? id;
    String? color;
     String? primercolor;
    String? type;
    int? width;
    int? height;
    int? top;
    int? left;
    bool? is_busy=false;
    String? holl_color;
     int? holl_width;
    int? holl_height;
    String? text;

  bool? is_owned=false;

  bool? is_taped=false;

  var counttape=0;
    
  PlaceModel({this.id,this.color,this.type,this.width,this.height,this.left,this.top,this.is_busy=false,this.text,this.primercolor}){
// Future databaseurl =Constants.get_sp("urldownloadjson");
//    databaseurl.then((url){ dburl = 'http://$url';});
  
  }
factory PlaceModel.fromMap(Map<String, dynamic> json) => new PlaceModel(
    id: int.parse(json["TAG"]),
    color: json["COLOR"],
    primercolor: json["COLOR"],
    width: int.parse(json["WIDTH"]),
    height: int.parse(json["HEIGHT"]),
    top:int.parse(json["TOP"]),
    left:int.parse(json["LEFT"]),
    type:json["TYPE"],
    text:json["TEXT"]
   
   
  );
   void loadHollPlace(List res){
      rows= res.isNotEmpty ? res.map((c) => PlaceModel.fromMap(c)).toList() : [];
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
   
  }
}