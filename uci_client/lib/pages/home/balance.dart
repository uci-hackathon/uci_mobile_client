import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';
import 'package:uci_client/widgets.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  UciBalance _uciBalance;

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      _uciBalance = await api.fetchUciBalance();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_uciBalance == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Liquid: ' + _uciBalance.liquid,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 20),
          Text(
            'Staked: ' + _uciBalance.staked,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
