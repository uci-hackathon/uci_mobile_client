import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uci_client/widgets.dart';

import 'apply_router.gr.dart';

class ApplyPage extends StatefulWidget {
  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: uciAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => ExtendedNavigator.of(context)
                  .pushNamed(Routes.applyForGrantPage),
              child: Card(
                child: Container(
                  width: double.infinity,
                  height: h * 0.3,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Apply for a grant',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .apply(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => print('apply grant'),
              child: Card(
                child: Container(
                  width: double.infinity,
                  height: h * 0.3,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Nominate custodian',
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .apply(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
