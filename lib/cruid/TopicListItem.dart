import 'package:flutter/widgets.dart';
class TopicListItem extends Object {
  final String? name;
  final Type type;
 // final List<String> uiname;
  final String iconame;
  const TopicListItem({@required this.name,this.type=String,this.iconame="img/settings.png"});
}