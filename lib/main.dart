import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cafe/HomeScreen.dart';
import 'package:cafe/Constants.dart';
import 'package:cafe/settinglist.dart';

void main() async{
  runApp(cafeHome());

}

class cafeHome extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('ru', 'RU'), // American English

        // ...
      ],
        /*
        routes: <String, WidgetBuilder>{
          // Set named routes
          SettingUIPage.routeName: (BuildContext context) => new SettingUIPage(),
        },
        */
      title: 'Cis-cafe',
      /*
      theme: ThemeData(

        primarySwatch: Colors.blue,
      //  backgroundColor: Colors.black,
      brightness: Brightness.light
      ),
      */
      theme: ThemeData.dark(),
      home:
      DefaultTabController(
      length: 2,
      child:
      HomePage(title: 'Кис Классика  Кафешка-Ресторанчик'),
      )//tab cinroller

    );
  }
}

class HomePage extends StatelessWidget  {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static void showMessage(String message, [MaterialColor color = Colors.green]) {
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
   /* _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
*/
  }

  static void showMessageaction(String message,String messagecallback,VoidCallback callback, [MaterialColor color = Colors.green]) {
   // _scaffoldKey.currentState.showSnackBar(
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context)..showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message),
        action: SnackBarAction(
            label: messagecallback,
            onPressed: callback
        ),
        ));
  }


  @override
  Widget build(BuildContext context) {
Constants.init(context);
    return Scaffold(
      key:_scaffoldKey,
        appBar: AppBar(
           title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.rowing)),
            //  Tab(icon: Icon(Icons.settings_input_hdmi)),
              Tab(icon: Icon(Icons.settings_applications),),
            ],
          ),
        ),
      body:body(),


    );//Scaffold

  }

  Widget body(){
    return TabBarView(
      children: [
        new  HomeScreen(),
       // Icon(Icons.directions_car),
      //  new InitDBui(),
        //Icon(Icons.settings_applications),
        new SettingList(),
        //new CisSetting(),
      ],
    );

  }

}

