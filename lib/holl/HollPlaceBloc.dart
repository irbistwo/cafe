import 'package:cafe/Reestr/ReestrModel.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:cafe/holl/HollPlaceModel.dart';
import 'package:cafe/holl/ParseXmlHoll.dart';
import 'package:cafe/holl/PlaceModel.dart';


class HollPlaceBloc extends cisBloc {
  List<ReestrModel> rows;

  int garson_id;
  HollPlaceBloc(this.rows,this.garson_id):super();

 

 
  @override
  Future <List<HollPlaceModel>> blocload() async{
    
    await HollPlaceModel.loadHoll();
  // print( 'xmltopology ${HollPlaceModel.rows[0].xmltopology}');
   HollPlaceModel.rows?.forEach((row) {
     if(row.xmltopology!=null) {
  ParseXmlHoll holl= new ParseXmlHoll(xmlstr: row.xmltopology);
  PlaceModel pl=new PlaceModel();
  pl.holl_color=holl.colorholl;
  if (holl.widthholl==null) holl.widthholl="300";
  if (holl.heightholl==null) holl.heightholl="300";
  pl.holl_width=int.parse(holl.widthholl!);
  pl.holl_height=int.parse(holl.heightholl!);
  pl.loadHollPlace(holl.result);
  _GraniePlace(pl);
  row.placemodel=pl;

     }
    });
  
    return HollPlaceModel.rows!;

  }

 void _GraniePlace(PlaceModel pl){
   if(this.rows==null) return;
   this.rows.forEach((row) {
  pl.rows?.forEach((rowpl) {
    if(rowpl.id==row.place_id){rowpl.is_busy=true;
    if(row.firmsomol_id==garson_id) rowpl.is_owned=true;
    }
    
    });
    });

 }  

}