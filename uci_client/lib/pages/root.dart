import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages.dart';

class RootPage extends StatelessWidget {
  final future = Hive.initFlutter();

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
