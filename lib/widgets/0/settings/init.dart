import 'package:dachstein_pistes/backgroundjob/init.dart';
import 'package:dachstein_pistes/db/init.dart';
import 'package:dachstein_pistes/db/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }

}

class SettingsPageState extends State<SettingsPage> {

  late Future<AppSettings> appSettings;

  @override
  void initState() {
    appSettings = get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettings>(
      future: appSettings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: TextEditingController(
                  text: snapshot.data!.refreshSettings.interval.toString()),
              decoration: const InputDecoration(
                  labelText: "Refresh every X minutes"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (String valueString) async {
                int? value = int.tryParse(valueString);
                if (value != null) {
                  AppSettings appSettings = await get();
                  appSettings.refreshSettings.interval = value;
                  await set(appSettings);
                  job();
                } else {
                  valueString = "60";
                }
              },
            ),
          );
        } else {
          return const Text("loading data ...");
        }
      },
    );
  }

}