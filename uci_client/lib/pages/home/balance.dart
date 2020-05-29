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
  var _isMinting = false;
  var _isStaking = false;

  void _mintToken() async {
    try {
      setState(() {
        _isMinting = true;
      });

      final q = 100;
      await Provider.of<UciApi>(context, listen: false).mintUciTokens(q);

      setState(() {
        _uciBalance.liquid += q;
        _isMinting = false;
      });
    } catch (_) {
      setState(() {
        _isMinting = false;
      });
    }
  }

  void _stakeToken({bool unstake = false}) async {
    try {
      setState(() {
        _isStaking = true;
      });

      final q = 100;
      final api = Provider.of<UciApi>(context, listen: false);
      if (unstake) {
        await api.unstakeUciTokens(q);
        _uciBalance.liquid += q;
        _uciBalance.staked -= q;
      } else {
        await api.stakeUciTokens(q);
        _uciBalance.liquid -= q;
        _uciBalance.staked += q;
      }

      setState(() {
        _isStaking = false;
      });
    } catch (_) {
      setState(() {
        _isStaking = false;
      });
    }
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
                'Liquid:\n' + _uciBalance.liquid.toStringAsFixed(1) + ' UCI',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .apply(color: Colors.white),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                child: _isMinting
                    ? LinearProgressIndicator()
                    : RaisedButton(
                        onPressed: _mintToken,
                        child: Text(
                          'Add',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        UciCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Staked:\n' + _uciBalance.staked.toStringAsFixed(1) + ' UCI',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .apply(color: Colors.white),
              ),
              Spacer(),
              _isStaking
                  ? LinearProgressIndicator()
                  : Row(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: _stakeToken,
                          child: Text(
                            'Stake',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                        Spacer(),
                        RaisedButton(
                          onPressed: () => _stakeToken(unstake: true),
                          child: Text(
                            'Unstake',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
