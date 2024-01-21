import 'package:cafe/dictionarycis/bloc/cisBloc.dart';

import 'hollButtonModel.dart';

class hollbuttonblockBloc extends cisBloc {
 
 int get_index(int holl_id){
   int i=-1;
   try{
   var row=HollButtonModel.rows?.firstWhere((item) => item.id==holl_id);
   if(row!=null) i=HollButtonModel.rows!.indexOf(row);
   } catch(e){}
   return i;
 }
  @override
  Future <List<HollButtonModel>> blocload() async{
    
    await HollButtonModel.loadfromAPI();
    //print(HollButtonModel.rows);
    return HollButtonModel.rows!;

  }
 
 

}