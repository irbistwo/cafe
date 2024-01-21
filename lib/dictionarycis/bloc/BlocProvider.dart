// 1
import 'package:flutter/cupertino.dart';
import 'package:cafe/dictionarycis/bloc/cisBloc.dart';

class BlocProvider<T extends Bloc>  extends InheritedWidget {
  final Widget child;
  final T? bloc;

  const BlocProvider({Key? key,  this.bloc, required this.child})
      : super(key: key,child: child);

  // 2
  static T? of<T extends Bloc>(BuildContext context) {
   // final type = _providerType<BlocProvider<T>>();
    //final BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    //final BlocProvider<T> provider = (context.findAncestorWidgetOfExactType) as BlocProvider<T>;
 final provider = context.dependOnInheritedWidgetOfExactType<BlocProvider<T>>();

    return provider!.bloc;
  }

  @override
  bool updateShouldNotify(BlocProvider old) => false;

  // 3
  static Type _providerType<T>() => T;

 // @override
  //State createState() => _BlocProviderState();
  
}


