import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<AppSettings> appSettings;

  void _togglePisteNotification(AppSettings? appSettings, Piste piste) {
    setState(() {
      piste.notification = !piste.notification;
      set(appSettings!);
    });
  }

  @override
  void initState() {
    super.initState();
    appSettings = get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<AppSettings>(
              future: appSettings,
              builder: (BuildContext context, AsyncSnapshot<AppSettings> snapshot) {
                if (snapshot.hasData) {
                  List<Widget> widgetList = [];
                  widgetList.add(const Text("Piste", textAlign: TextAlign.center,));
                  widgetList.add(const Text("State", textAlign: TextAlign.center,));
                  widgetList.add(const Text("Notification", textAlign: TextAlign.center,));
                  for (var piste in snapshot.data!.pistes) {
                    widgetList.add(Text(piste.name, textAlign: TextAlign.center,));
                    widgetList.add(Text(piste.state, textAlign: TextAlign.center,));
                    widgetList.add(
                        Checkbox(value: piste.notification,
                          onChanged: (value) => _togglePisteNotification(snapshot.data, piste),
                        ));
                  }
                  return GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    childAspectRatio: 10,
                    children: widgetList
                  );
                } else {
                  return const Text('Could not fetch pistes yet');
                }
              }
            )
        );
  }
}
