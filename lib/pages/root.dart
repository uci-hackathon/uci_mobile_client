import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/widgets.dart';

import '../repository/repository.dart';
import 'pages.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

enum _RootState {
  loading,
  onboarding,
  home,
}

class _RootPageState extends State<RootPage> {
  var _state = _RootState.loading;

  @override
  void initState() {
    Future.microtask(() async {
      final isRegistered =
          await Provider.of<UciApi>(context, listen: false).isRegistered();
      if (isRegistered) {
        _state = _RootState.home;
      } else {
        _state = _RootState.onboarding;
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _RootState.home:
        return HomePage();

      case _RootState.onboarding:
        return OnboardingPage();

      case _RootState.loading:
        return Scaffold(
          appBar: UciAppBar(),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    return Container();
  }
}
