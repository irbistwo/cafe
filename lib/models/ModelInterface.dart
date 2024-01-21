abstract class ModelInterface{
 Future? load({String filter="",String? orderby});
  List get list;
  Map<String, dynamic>? toMap();
}