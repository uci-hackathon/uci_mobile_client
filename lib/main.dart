import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/router.gr.dart';

import 'repository/repository.dart';
import 'theme.dart';

void main() async {
  await Hive.initFlutter();
  final prefs = Prefs();
  final api = UciApi(prefs: prefs);
  Hive.registerAdapter(UciAccountAdapter());

  runApp(UCIApp(
    prefs: prefs,
    api: api,
  ));
}

class UCIApp extends StatelessWidget {
  final Prefs prefs;
  final UciApi api;

  UCIApp({this.prefs, this.api});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: prefs),
        Provider.value(value: api),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: uciTheme,
        builder: ExtendedNavigator<Router>(router: Router()),
      ),
    );
  }
}
