import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // get remote config
  final remoteConfig = await RemoteConfig.instance;

  // setup default values
  final defaults = <String, dynamic>{'welcome': 'Hello World!'};
  await remoteConfig.setDefaults(defaults);

  // get last config data
  final text = remoteConfig.getString('welcome');

  // run app and use config data
  runApp(MyApp(text));

  // fetch and activate config data, data will be used in next restart
  await remoteConfig.fetch(expiration: Duration.zero);
  await remoteConfig.activateFetched();
  print('Welcome text is ' + remoteConfig.getString('welcome'));
}

class MyApp extends StatefulWidget {
  final String text;

  MyApp(this.text);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(text);
  }
}

class MyAppState extends State<MyApp> {
  /*@override
   void initState(){
  _refreshConfig().then((value){print('Async');
  });
  super.initState();
  }*/
  Timer timer;

@override
void initState() {
  super.initState();
  timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _refreshConfig());
}

/*@override
void dispose() {
  timer?.cancel();
  super.dispose();
}*/

  final _title = 'Firebase Config Demo';
  String text;

  MyAppState(this.text);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(_title),
          ),
          body: Center(
            child: Text(text),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: _refreshConfig,
          ),
        ));
  }

  Future _refreshConfig() async {
    await Future.delayed(Duration(seconds: 2));
    print("Config refresh!");

    // get remote config
    final remoteConfig = await RemoteConfig.instance;

    // fetch and activate config data, data will be used in next restart
    await remoteConfig.fetch(expiration: Duration.zero);
    await remoteConfig.activateFetched();
    print('Welcome text is ' + remoteConfig.getString('welcome'));

    setState(() {
      text = remoteConfig.getString('welcome');
    });
  }
  
 
}
