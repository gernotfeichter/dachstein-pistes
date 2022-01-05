import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:dachstein_pistes/backgroundjob/init.dart';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  MyHomePageState() {
    ReceivePort receivePort = ReceivePort("backgroundJobFinished");
    sendPort = receivePort.sendPort;
    receivePort.listen((message) { _backgroundJobFinished(); });
  }

  static http.Response? response;

  late Future<AppSettings> appSettings;

  static late SendPort sendPort;

  void _togglePisteNotification(AppSettings? appSettings, Piste piste) {
    setState(() {
      piste.notification = !piste.notification;
      set(appSettings!);
    });
  }
  
  Future<void> _backgroundJobFinished() async {
    log("message channel: message received");
    setState(() {
      log("background job finished, refreshing ui");
      appSettings = get();
    });
  }

  @override
  void initState() {
    log("init state called");
    super.initState();
    job();
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
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Could not fetch pistes at all.'),
                );
              }
            }));
  }

}
