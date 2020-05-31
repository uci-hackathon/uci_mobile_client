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
  final _loaderKey = GlobalKey<LoadingPlaceholderState>();

  Future _mintToken() async {
    final q = 200;
    await Provider.of<UciApi>(context, listen: false).mintUciTokens(q);
    await Provider.of<UciApi>(context, listen: false).stakeUciTokens(100);

    setState(() {
      _uciBalance.liquid += 100;
    });
  }

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

    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        UciCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Purchased:\n' +
                    _uciBalance.liquid.toStringAsFixed(1) +
                    ' VOTE',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .apply(color: Colors.white),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                child: LoadingPlaceholder(
                  type: LoaderType.embed,
                  key: _loaderKey,
                  child: UciButton(
                    onPressed: () => _loaderKey.currentState.load(_mintToken),
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
