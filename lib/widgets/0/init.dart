import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:dachstein_pistes/backgroundjob/init.dart';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    receivePort.listen((message) {
      _backgroundJobFinished();
    });
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
    var columnWidths = const {
      0: FlexColumnWidth(5),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(3),
    };
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<AppSettings>(
            future: appSettings,
            builder:
                (BuildContext context, AsyncSnapshot<AppSettings> snapshot) {
              if (snapshot.hasData) {
                List<TableRow> widgetListHeader = [];
                List<TableRow> widgetListContent = [];
                widgetListHeader.add(const TableRow(children: [
                  Text(
                    "Piste",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "State",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Notification",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ]));
                for (var piste in snapshot.data!.pistes) {
                  widgetListContent.add(TableRow(
                      children: [
                        Text(
                          piste.name,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          piste.state,
                          textAlign: TextAlign.center,
                        ),
                        Checkbox(
                          value: piste.notification,
                          onChanged: (value) =>
                              _togglePisteNotification(snapshot.data, piste),
                        )
                      ]
                  )
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          children: widgetListHeader,
                          columnWidths: columnWidths
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          children: widgetListContent,
                          defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                          columnWidths: columnWidths
                          // border: TableBorder.all(),
                        ),
                      ),
                    ]
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Could not fetch pistes at all.'),
              );
            }
          }));
  }
}
