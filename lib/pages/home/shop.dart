import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:uci_client/widgets.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UciAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          UciCard(
            onPressed: () => FlushbarHelper.createInformation(
              message:
                  'here will be all the partners shops that accept USDT from our wallet to buy stuff',
            )..show(context),
            child: Text(
              'Shop UCi Merch',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          UciCard(
            onPressed: () => FlushbarHelper.createInformation(
              message:
                  'here will be all the partners shops that accept USDT from our wallet to buy stuff',
            )..show(context),
            child: Text(
              'Browse retail partners',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
