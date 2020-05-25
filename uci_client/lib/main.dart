import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uci_client/router.gr.dart';

import 'theme.dart';

void main() {
  runApp(UCIApp());
}

class UCIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uciTheme,
      builder: ExtendedNavigator<Router>(router: Router()),
    );
  }
}
