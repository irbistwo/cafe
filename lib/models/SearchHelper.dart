class SearchHelper{
  static   List<SearchHelper>? items;
  final int? id;
  final String? name;
  SearchHelper({this.id,this.name});
  factory SearchHelper.fromMap(Map<String, dynamic> json) => new SearchHelper(
      id: json["id"],
      name: json["name"]
  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,

  };
  static Future load(String sql) async {
   // final db =  await sqldb.DBProvider.db.database;
   // var res =  await db.rawQuery(sql);

    //items= res.isNotEmpty ? res.map((c) => SearchHelper.fromMap(c)).toList() : [];
    //print(firms);
  }
}