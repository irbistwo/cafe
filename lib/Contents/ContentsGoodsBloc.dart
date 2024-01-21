import 'package:cafe/Reestr/ReestrModel.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';

import 'ContentsModel.dart';





class ContentsGoodsBloc extends cisBloc {
  int document_id=0;
  ContentsGoodsBloc({required int document_id}):this.document_id=document_id,super();
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




  @override
  Future <List<ContentsModel>> blocload() async{
    ContentsModel.rowstogui=[];
    await ContentsModel.loadfromAPI(document_id);
   // print(ContentsModel.rows);
    return ContentsModel.rowstogui;

  }

}