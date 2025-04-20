import 'package:dachstein_pistes/widgets/settings/init.dart';
import 'package:flutter/material.dart';

import '../init.dart';

class NavigationDrawerWidget extends StatefulWidget {

  const NavigationDrawerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {

  _NavigationDrawerWidgetState();

  void switchPageAndCloseDrawer(Widget widget) {
    MainPageState.instance.switchPage(widget);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(0, 0, 0, 0.1),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Pistes"),
              onTap: () {
                switchPageAndCloseDrawer(
                    pistesPageFutureBuilder());
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                switchPageAndCloseDrawer(const SettingsPage());
              },
            ),
          ],
        ),
      ),
    );
  }

}
