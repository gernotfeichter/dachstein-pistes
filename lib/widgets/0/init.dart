import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:dachstein_pistes/backgroundjob/init.dart';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:dachstein_pistes/globals/init.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'navigation.dart';

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
      home: const MainPage(title: title),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  static late  MainPageState instance;
  static bool instanceSet = false;

  late Widget currentPage;

  late Future<AppSettings> appSettings;

  static http.Response? response;

  late Timer timer;

  SendPort getSendPort() {
    ReceivePort receivePort = ReceivePort("backgroundJobFinished");
    SendPort sendPort = receivePort.sendPort;
    receivePort.listen((message) {
      _backgroundJobFinished();
    });
    return sendPort;
  }

  void _togglePisteNotification(AppSettings? appSettings, Piste piste) async {
    piste.notification = !piste.notification;
    await set(appSettings!);
    appSettingsUpdate();
  }

  Future<void> _backgroundJobFinished() async {
    log("message channel: message received");
    appSettingsUpdate();
  }

  void appSettingsUpdate() {
    setState(() {
      appSettings = get();
      if (currentPage is FutureBuilder<AppSettings>) {
        log("currentPage is FutureBuilder<AppSettings>, refreshing ui");
        log("oldCurrentPage=${currentPage.hashCode}");
        currentPage = pistesPageFutureBuilder();
        log("newCurrentPage=${currentPage.hashCode}");
      }
    });
  }

  void switchPage(Widget widget){
    setState(() {
      currentPage = widget;
    });
  }

  @override
  void initState() {
    log("initState called");
    super.initState();
    instance = this;
    instanceSet = true;
    appSettings = get();
    currentPage = pistesPageFutureBuilder();
    job();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) async {
      log("timed refresh of ui");
        // Refresh ui every minute, as this is the maximum amount of refresh
        // frequency as per config and equals Android Alarm Manager limitation).
        // Normally the SendPort would communicate that it is finished,
        // but retrieving the static Handle to
        AppSettings appSettingsSnapshot = await get();
        log("attempting refresh ui with date = "
            "${appSettingsSnapshot.refreshSettings.last} (pid=$pid)");
        appSettingsUpdate();
    });
  }


  @override
  void didUpdateWidget(MainPage oldWidget) {
    log("didUpdateWidget called");
    super.didUpdateWidget(oldWidget);
    appSettings = get();
    currentPage = pistesPageFutureBuilder();
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: const NavigationDrawerWidget(),
        body: currentPage);
  }

}

FutureBuilder<AppSettings> pistesPageFutureBuilder() {
  var columnWidths = const {
    0: FlexColumnWidth(5),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(3),
  };
  Future<AppSettings> appSettings = get();
  return FutureBuilder<AppSettings>(
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
                        MainPageState.instance._togglePisteNotification(snapshot.data, piste),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "last refreshed: " +
                          snapshot.data!.refreshSettings.last,
                    ),
                  )
                ]
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Could not fetch pistes at all.'),
          );
        }
      });
}