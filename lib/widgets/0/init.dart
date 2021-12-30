import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:flutter/cupertino.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
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
            builder:
                (BuildContext context, AsyncSnapshot<AppSettings> snapshot) {
              if (snapshot.hasData) {
                List<Widget> widgetListHeader = [];
                List<Widget> widgetListContent = [];
                widgetListHeader.add(const Text(
                  "Piste",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
                widgetListHeader.add(const Text(
                  "State",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
                widgetListHeader.add(const Text(
                  "Notification",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
                for (var piste in snapshot.data!.pistes) {
                  widgetListContent.add(Center(
                      child: Text(
                    piste.name,
                    textAlign: TextAlign.start,
                  )));
                  widgetListContent.add(Center(
                      child: Text(
                    piste.state,
                    textAlign: TextAlign.center,
                  )));
                  widgetListContent.add(
                    Center(
                        child: Checkbox(
                      value: piste.notification,
                      onChanged: (value) =>
                          _togglePisteNotification(snapshot.data, piste),
                    )),
                  );
                }
                return Column(children: [
                  Flexible(
                      flex: 1,
                      child: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 30,
                          crossAxisCount: 3,
                          childAspectRatio: 1.3,
                          children: widgetListHeader)),
                  Flexible(
                      flex: 15,
                      child: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 30,
                          crossAxisCount: 3,
                          childAspectRatio: 1.3,
                          children: widgetListContent))
                ]);
              } else {
                return const Text('Could not fetch pistes yet');
              }
            }));
  }
}
