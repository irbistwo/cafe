import 'package:cafe/dictionarycis/bloc/cisBloc.dart';

import 'ReestrModel.dart';



class ReestrBloc extends cisBloc {
  int garson_id=0;
  ReestrBloc({required int garson_id}):this.garson_id=garson_id,super();
 /*
 int get_index(int holl_id){
   int i=-1;
   try{
   var row=ReestrModel.rows?.firstWhere((item) => item.id==holl_id);
   if(row!=null) i=ReestrModel.rows.indexOf(row);
   } catch(e){}
   return i;
 }
 */

void filterGarson(int garson_id){
   List<ReestrModel> listresult=ReestrModel.rows!;
   listresult=listresult.where((item)=>item.firmsomol_id==garson_id).toList();
   SetList(listresult);

}

List<ReestrModel>  filterGarsonandPlace(int place_id){
   List<ReestrModel> listresult=ReestrModel.rows!;
   listresult=listresult.where((item)=>item.firmsomol_id==this.garson_id).toList();
  listresult=listresult.where((item)=>item.place_id==place_id).toList();
   SetList(listresult);
   return listresult;
}
@override
Future<void> load() async{
   
   if(this.garson_id!=0) {
   await  blocload();
   filterGarson(this.garson_id);

   }
   else super.load();
  }

  @override
  Future <List<ReestrModel>> blocload() async{
    
    await ReestrModel.loadfromAPI();
    //print(HollButtonModel.rows);
    return ReestrModel.rows!;

  }
 
 

}