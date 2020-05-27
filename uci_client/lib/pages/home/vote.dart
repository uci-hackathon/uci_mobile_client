import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/models/account.dart';
import 'package:uci_client/repository/repository.dart';

import '../../widgets.dart';

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _CustodianViewModel {
  _CustodianViewModel({this.username});

  String username;
  UciAccount uciAccount;
  var isSelected = false;

  bool get isFetchingDetails => uciAccount == null;
}

class _VotePageState extends State<VotePage> {
  List<_CustodianViewModel> _custodians;
  var _buttonOpacity = 0.0;

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      final usernames = await api.fetchNominates();
      print(usernames);
      _custodians =
          usernames.map((e) => _CustodianViewModel(username: e)).toList();
      setState(() {});

      _custodians.forEach((c) async {
        c.uciAccount = await api.fetchMetadata(c.username);
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buttonOpacity == 0.0
          ? Container()
          : AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: _buttonOpacity,
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => print('VOTE FOR CUSTODIANS'),
                  child: Text(
                    'Submit vote',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: uciAppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Vote for 8 custodians',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          _custodians == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: _custodians.length,
                    itemBuilder: (_, index) => _buildCustodianTile(
                      _custodians[index],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCustodianTile(_CustodianViewModel custodian) {
    return CheckboxListTile(
      value: custodian.isSelected,
      onChanged: (val) => setState(() {
        custodian.isSelected = val;
        final selectedCount = _custodians.fold(
            0,
            (previousValue, element) =>
                previousValue += element.isSelected ? 1 : 0);
        _buttonOpacity = selectedCount >= 2 ? 1.0 : 0.0;
      }),
      title: Text(
        custodian.username,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: FlatButton(
        onPressed: () => print('REVIEW!'),
        child: custodian.isFetchingDetails
            ? LinearProgressIndicator()
            : Text(
                'Review >',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
      ),
    );
  }
}
