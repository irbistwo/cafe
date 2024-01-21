import 'package:cafe/dictionarycis/bloc/cisBloc.dart';
import 'package:cafe/models/SearchHelper.dart';
class searchBloc extends cisBloc {
  searchBloc(String sql):super(sql:sql);
  @override
  Future <List<SearchHelper>> blocload() async{
    await SearchHelper.load(sql!);
    return SearchHelper.items!;

  }
  @override
  void filter(String filter){

    List listresult=SearchHelper.items!;
    // _search=search;
    if(filter=="") {SetList(listresult); return;}

    listresult=listresult.where((item)=>item.name.toUpperCase().contains(filter.toUpperCase())).toList();

    SetList(listresult);
  }
}