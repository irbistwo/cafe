import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:intl/intl.dart";

import 'ContentsModel.dart';
typedef void updinAPI(double quantity, int increment);
class UpdateContents extends StatefulWidget {
  final ContentsModel contentModel;
  final updinAPI updinapi;
  UpdateContents(this.contentModel,this.updinapi);
  @override
  _UpdateContentsState createState() => new _UpdateContentsState();

}

class _UpdateContentsState extends State<UpdateContents> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
late String _value;
late String _price;
int _deletestate=0;
Color? _colorbuttondel=Colors.red[200];
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerplusminus = new TextEditingController();
  TextEditingController _controllerprice = new TextEditingController();
  void showMessage(String message, [MaterialColor color = Colors.green]) {

    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));

  }

  @override
  void initState() {
    // _list=TitleModel.titles;
    // _list=SectionModel.items;
    super.initState();
    _value=widget.contentModel.quantity.toString();
    _controller.text=(_value==null?'':_value);
    _price=widget.contentModel.prsellcost.toString();
    _controllerprice.text=(widget.contentModel.prsellcost==null?'':_price);

  }
  Widget get _tquantity {

    TextInputType keyboardType=TextInputType.number;

    String label="Количество";
    //int inticon= int.parse("0xe0e4");
    return new TextFormField(
        key:new ObjectKey("quantity"),
        decoration:  InputDecoration(
          icon:  Icon(Icons.high_quality),
          hintText: 'Введите '+label,
          labelText:label,// ('URL загрузки'+"jj"+n),
        ),
        controller: _controller ,
        keyboardType: keyboardType,
        onSaved: (val) => _onSaved(val!)//_paramvalue = val
    );

  }

void  _onSaved(String val){
   _value=val;
  }

  Form get _form{
    return new Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: _tquantity
    );
  }

  Widget get _tprice {

    TextInputType keyboardType=TextInputType.number;

    String label="Цена";
    //int inticon= int.parse("0xe0e4");
    return new TextFormField(
        key:new ObjectKey("prsellcost"),
        decoration:  InputDecoration(
          icon:  Icon(Icons.high_quality),
          hintText: 'Введите '+label,
          labelText:label,// ('URL загрузки'+"jj"+n),
        ),
        controller: _controllerprice ,
        keyboardType: keyboardType,
        onSaved: (val){_price=val!;}//_paramvalue = val
    );

  }

  Form get _formprice{
    return new Form(
        key: _formKey2,
        autovalidateMode: AutovalidateMode.always,
        child: _tprice
    );
  }
  void _submitForm() {
    //print(_value);
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      showMessage('Form is not valid!  Please review and correct.',Colors.red);
      return;
    }
    form!.save();
    _updategoods();
   // print(_value);
    // SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    // saveprefvalue();
    showMessage('Количество изменено');

_close();

  }

  void _submitFormPrice() {
    //print(_value);
    final FormState? form = _formKey2.currentState;
    if (!form!.validate()) {
      showMessage('Form is not valid!  Please review and correct.',Colors.red);
      return;
    }
    form.save();
    _updategoodsprice();
    // print(_value);
    // SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    // saveprefvalue();
    //s
    showMessage('Изменение цены на мобильном устройстве запрещено политикой организации',Colors.orange);

    //_close();

  }

  _close(){

    Future f= new Future.delayed(const Duration(seconds: 1));

    f.then((b)=>Navigator.pop(context));
  }
  void _updategoods() async{
  var quantity=0.0;
  quantity=_parsespec(_value);
 // quantity--;
  print(quantity);
  widget.updinapi(quantity,0);
    //await ContentModel.insertORreplace(row, widget.contentModel.document_id);
  }

  void _updategoodsprice() async{
    //Я сделал два метода ибо изменение цен может быть отменено политикой безопасности предприятия
    var quantity=0.0;
    quantity=_parsespec(_value);
    quantity--;
    var price=_parsespec(_price);
    print(price);
    
    //await ContentsModel.insertORreplace(row, widget.contentModel.document_id);
  }
  Widget get _savebutton {
 return   new Container(
        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
        child: new ElevatedButton (
          child: const Text('Изменить'),
          onPressed:()=>_submitForm()
        ));
  }

  Widget get _savebuttonprice {
    return   new Container(
        padding: const EdgeInsets.only(left: 40.0, top: 10.0),
        child: new ElevatedButton (
            child: const Text('Изменить Цену'),
            onPressed:()=>_submitFormPrice()
        ));
  }

  _deleteitem() async{
  switch (_deletestate){
    case 0:
    showMessage("Нажмите ещё раз после смены цвета кнопки и позиция будет удалена ");
   await new Future.delayed(const Duration(seconds: 1));
setState(() {
  _deletestate++;
  _colorbuttondel=Colors.red;
});

    break;
   case 1: _deletestate--;
   widget.updinapi(-1,0);
   //await ContentsModel.delcontents(contid: widget.contentModel.id);
   showMessage("Позиция ${widget.contentModel.goodsname}  удалена ");
   _close();
    break;
    default:setState(() {
      _deletestate=0;
      _colorbuttondel=Colors.red[300];
    });
  }
  }


  Widget get _delbutton {
    return   new Container(
        padding: const EdgeInsets.only(left: 100.0, top: 40.0,right: 100),
        child: new ElevatedButton (
          style: ElevatedButton.styleFrom(
              backgroundColor:  _colorbuttondel),
            child: const Text('Удалить позицию'),
            onPressed:()=>_deleteitem()
        ));
  }

  double _parsespec(String text){
  var s=text;
   s= s.replaceAll('\u00A0', "");
    s=s.replaceAll(",", ".");
    s=s.replaceAll("/", ".");
    s=s.replaceAll("*", ".");
  var d = double.parse(s);
  return d;
  }

  void _plusminus(double d){
    var squantity=_controller.text;
  //  squantity=squantity.replaceAll('\u00A0', "");
  //  print(squantity);
    var dquantity=_parsespec(squantity);

    var result=d+dquantity;
    final f = new NumberFormat("###,###,##0.00","ru");
    final sres = f.format(result);
    _controller.text=sres.toString();

  }

  Widget get _plusminesrow {
  String label="+\- Количество";
    return
     new Container(
       padding: const EdgeInsets.only(left: 40.0),
         height: 50.0,
        // width: 100,
         child:
      new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [ /*new Container(
        padding: const EdgeInsets.only(left: 40.0, top: 5.0),
        child: new RaisedButton(
            child: const Text('+'),
            onPressed:(){
              _controller.text="+";
            }
        )
      )
      */
            new ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.blue[200]),
                child: const Text('+'),
                onPressed:(){
                 // _controller.text="+";
                  var s=_controllerplusminus.text;

                 try {
                  var d=_parsespec(s);
                  // print(d);
                   _plusminus(d);
                 }catch (e){
                   showMessage(e.toString(),Colors.red);
                 }
                }
            ),

    Expanded( child:  new TextField(

            key:new ObjectKey("quantityplusminus"),
    decoration:  InputDecoration(

    icon:  Icon(Icons.high_quality),
    hintText: 'Введите '+label,
    labelText:label,// ('URL загрузки'+"jj"+n),
    ),

    controller: _controllerplusminus ,
       // inputFormatters: [WhitelistingTextInputFormatter.],
    keyboardType: TextInputType.number
   // onSaved: (val) => _onSaved(val)//_paramvalue = val
    )
    ),
            new ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red[200]),
                child: const Text('-'),
                onPressed:(){
                  {
                    // _controller.text="+";
                    var s=_controllerplusminus.text;

                    try {
                      var d=-_parsespec(s);
                      // print(d);
                      _plusminus(d);
                    }catch (e){
                      showMessage(e.toString(),Colors.red);
                    }
                  }
                }
            )

          ]
      )
     );
  }
  Widget get body{
    return Padding(
        padding: EdgeInsets.all(02.0),
    child:
    ListView(children: [
      _form,_savebutton,_plusminesrow,_delbutton,_formprice,_savebuttonprice

    ]
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold( key: _scaffoldKey,
    body: body,
        bottomNavigationBar: BottomAppBar(
          child: Container(height: 50.0,
            child:   new ListTile(
              title:new Text("${widget.contentModel.goodsname}:" ,textScaleFactor: 0.9,),//new Text("Итого ${TitleModel.getsummstr()}"),
            //  trailing:new Text(" $summa"),
              // subtitle:new Text("${widget.titleModel.firmsname}") ,
            ),


          ),

        )
    );
  }


}