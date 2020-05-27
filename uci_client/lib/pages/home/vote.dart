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

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      final usernames = await api.fetchCustodians();
      _custodians =
          usernames.map((e) => _CustodianViewModel(username: e)).toList();
      setState(() {});

//      _custodians.forEach((c) async {
//        c.uciAccount = await api.fetchMetadata(c.username);
//        setState(() {});
//      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uciAppBar(),
      body: Column(
        children: <Widget>[
          Text(
            'Vote for 8 custodians',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 20),
          _custodians == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
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
      onChanged: (val) => setState(() => custodian.isSelected = val),
      title: Text(
        custodian.username,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: FlatButton(
        onPressed: () => print('REVIEW!'),
        child: Text(
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
