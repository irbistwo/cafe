import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../Constants.dart';
typedef onErrorCallBack(Exception error);
class ApiRequest{
static  Future<String> apiRequest(String url,Map jsonMap) async {
   
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Content-type', 'application/json');
     //request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
      //print(reply);
    return reply;}
    else throw response.reasonPhrase;
    //return null;
  }

  static  Future<String> apiSocket(String data,onErrorCallBack onError) async{
     var completer = new Completer<String>();
     if(Constants.printurl==null) Constants.printurl= await  Constants.get_sp("urldownload1");
   //Constants.printurl='http://${Constants.printurl}';
    String? url=Constants.printurl;
   // urldownload1
    int port=5656;
    Socket.connect(url, port).then((socket)  {
    print('Connected to: '
      '${socket.remoteAddress.address}:${socket.remotePort}');
   
    //Establish the onData, and onDone callbacks
    socket.listen((data) {
     
      String res=new String.fromCharCodes(data).trim();
      print(res);
      completer.complete(res);
      
    },
    onDone: () {
      print("Done");
      socket.destroy();
    });
  //print(data);
    //Send the request
     socket.write(data);
    socket.flush().then((value) {socket.close();});
  }).catchError((error) {print("error2 $error");onError(error);});

  
 return completer.future;
  }
}