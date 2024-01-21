import 'dart:async';
import 'dart:io';

import 'package:cafe/holl/Holl.dart';
import 'package:flutter/material.dart';
//import 'package:cafe/utils/PermissionRule.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'Constants.dart';
import 'Reestr/ReestrBlock.dart';
import 'Reestr/ReestrModel.dart';
import 'dictionarycis/bloc/BlocProvider.dart';
import 'garson/GarsonModel.dart';
import 'holl/HollPlaceBloc.dart';
import 'holl/hollButtonBlock.dart';

typedef void Clickbutton(int id,BuildContext context);
class HomeScreen extends StatelessWidget {
  static Widget rbuildButtonColumn(BuildContext context,String iconpath, String label,Clickbutton voidpress,int id) {
    Color? color = Theme.of(context).textTheme.headline4?.color;
    Image image=  new Image.asset(
      iconpath,
      width: 80.0,
      height: 80.0,
      fit: BoxFit.fill,
    );
    var iconbutton= IconButton(
      icon: image,//Icon(Icons.volume_up),
    //  tooltip: 'Download dbfile%',
      iconSize:60.0,
      splashColor:Colors.green,
      disabledColor: Colors.red,
      onPressed: () async{
        voidpress(id,context);
// pressup();
        // uploadFile();
      },
    );



    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        // raisedbutton,
        // floatingActionButton,
        iconbutton,
        // flatbutton,
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );


  }
  Future<void> showreestr(int id,BuildContext context)  async{
/*
  await TitleModel.loadtitles();


  final result=await  Navigator.push(context,MaterialPageRoute(
  builder: (context) => DocumentTitles(), ),  );
  print(result);

  if(result!=null) insupdtitle(result,context);
*/
  }



   
   Future<void> _AutorizeClick(int id, BuildContext context) async {
try{
await GarsonModel.loadfromAPI();
}
catch(e){
  print(e);
  final snackBar = SnackBar(content: Text('Не удалось получить реквезиты...возможно нет связи с сервером!'+e.toString()));
//Scaffold.of(context)
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
if(GarsonModel.rows==null){
  

 //HomePage.showMessage('Не удалось получить реквезиты...возможно нет связи с сервером!',Colors.red);
  return;
}
  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
   final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

   _onPasscodeEntered(String enteredPasscode) {
    var storedPasscode="0000";
    bool isValid=false;
    try{
 var row=GarsonModel.rows?.firstWhere((item) => item.pocketcode==enteredPasscode);
 Constants.garsonrow=row;
if(row!=null)  {isValid=true;
final snackBar = SnackBar(backgroundColor: Colors.pink[100],content: Text('${row.name} Авторизован!'));
ScaffoldMessenger.of(context).
showSnackBar(snackBar);
}
    }
 catch(e){

 }
    
    //bool isValid = storedPasscode == enteredPasscode;
 _verificationNotifier.add(isValid);
    
  }

bool opaque=false;
Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
              title: Text(
              'Введите код',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
           // circleUIConfig: circleUIConfig,
           // keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: Text(
              'Отмена',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          
            deleteButton: Text(
              'Удалить',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            //digits: digits,
            passwordDigits: 4,
           // bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  Future<void> _HollClick(int id,BuildContext context) async {
    if(Constants.garsonrow==null){
      _AutorizeClick(id, context);
      return;
    }
    //HollPlaceModel.loadHoll();
    String? tempPath= Constants.tempDir?.path;
    var fbool=await File('$tempPath/hollid').exists();
    int holl_id=-1;
    if(fbool) {
       final file =File('$tempPath/hollid');
    // Read the file.
    String contents = await file.readAsString();
    try {
      holl_id=int.parse(contents);
    } on Exception catch (e) {
          // TODO
    }
    }
    ReestrBloc reestrBloc=new  ReestrBloc(garson_id: Constants.garsonrow!.id!);
    await reestrBloc.load();
    HollPlaceBloc hpbloc=new HollPlaceBloc(ReestrModel.rows!,Constants.garsonrow!.id!);
    await hpbloc.load();

   // reestrBloc.load();
    hollbuttonblockBloc bloc=new  hollbuttonblockBloc();
    await bloc.load();
     Widget holl= new BlocProvider( child: new Holl(buttonholbloc: bloc,hpbloc: hpbloc,reestrbloc:reestrBloc,initholl_id:holl_id));
                        
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => holl,
                   ),
           );

  }

  void PermissionClick(int id,BuildContext context){
  /*
    Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => {PermissionRule()},
                   ),
           );
*/
  }

  Future<void> insupdtitle(int id,BuildContext context)  async{
  
 
  }

  @override
  Widget build(BuildContext context) {
    return
      new Column(
          children: [new Container(
            padding: const EdgeInsets.only(top:8.0),
            // margin: const EdgeInsets.only(top:12.0),
            // color: const Color(0xFF00FF00),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [

                rbuildButtonColumn(context,'img/list.png', 'Показать реестр',showreestr,0),
               // rbuildButtonColumn(context,'img/user.png', 'Новый заказ',insupdtitle,-1),
              //  rbuildButtonColumn(context,'img/references.png', 'Контрагенты',insupdtitle,0),
                // rbuildButtonColumn(context,'img/doc_prodaja.png', 'Общее'),

              ],
            ),
          ),
          new Container(
          //padding: const EdgeInsets.only(top:8.0),
  // margin: const EdgeInsets.only(top:12.0),
  // color: const Color(0xFF00FF00),
           child:  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  crossAxisAlignment:CrossAxisAlignment.start,
           children: [
            
             rbuildButtonColumn(context,'img/doc_refresh.png', 'Разрешения',PermissionClick,-1),
                    ]

                    )
  ),

          new Container(
          //padding: const EdgeInsets.only(top:8.0),
  // margin: const EdgeInsets.only(top:12.0),
  // color: const Color(0xFF00FF00),
           child:  Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  crossAxisAlignment:CrossAxisAlignment.start,
           children: [
             rbuildButtonColumn(context,'img/44.png', 'Авторизация',_AutorizeClick,-1),
                          rbuildButtonColumn(context,'img/calendar.png', 'Показать зал',_HollClick,-1),
                       //   rbuildButtonColumn(context,'img/doc_refresh.png', 'Разрешения',PermissionClick,-1),
                                 ]
             
                                 )
               )
                                  ]
                   );
               }
             
             
             
             
}