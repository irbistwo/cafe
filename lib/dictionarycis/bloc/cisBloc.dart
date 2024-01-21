import 'dart:async';
import 'package:cafe/sp/SPcis.dart';


abstract class Bloc{
  Future<List> blocload();
  void dispose();
}
class cisBloc implements Bloc{
  String? sql;
  String? sqlinsert;
  String? sqlupdate;
  String? sqldelete;
  List<String>? argnamefororeder;
  Map<SpDescribe,dynamic>? msp;
  final _listController = StreamController<List>();
  Stream<List> get streamlist =>_listController.stream;
  cisBloc({ this.sql});

  void SetList(List list){
    _listController.sink.add(list);
  }

  Future <List> blocload() async{
   //Переназначем логику загрузки в потомках
       return null as Future <List>;
  }

  void filter(String filter){

  }

  void update(dynamic row){

  }



  Future<void> load() async{
    var result=await blocload();
    _listController.sink.add(result);
  }
  @override
  void dispose() {
    _listController.close();
  }

}