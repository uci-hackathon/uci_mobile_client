import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/models/account.dart';
import 'package:uci_client/repository/repository.dart';

import '../../widgets.dart';
import 'vote_router.gr.dart';

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _NominateeViewModel {
  _NominateeViewModel({this.username});

  String username;
  UciAccount uciAccount;
  var isSelected = false;

  bool get isFetchingDetails => uciAccount == null;
}

class _VotePageState extends State<VotePage> {
  List<_NominateeViewModel> _nominates;
  var _buttonOpacity = 0.0;

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      final usernames = await api.fetchNominates();
      _nominates =
          usernames.map((e) => _NominateeViewModel(username: e)).toList();
      setState(() {});

      _nominates.forEach((c) async {
        c.uciAccount = await api.fetchMetadata(c.username);
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: _buttonOpacity,
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: RaisedButton(
            onPressed: _buttonOpacity > 0.0
                ? () => Provider.of<UciApi>(context, listen: false).submitVote(
                      _nominates
                          .where((c) => c.isSelected)
                          .map((e) => e.username)
                          .toList(),
                    )
                : null,
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
          _nominates == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: _nominates.length,
                    itemBuilder: (_, index) => _buildNominateeTile(
                      _nominates[index],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildNominateeTile(_NominateeViewModel custodian) {
    return CheckboxListTile(
      value: custodian.isSelected,
      onChanged: (val) => setState(() {
        custodian.isSelected = val;
        final selectedCount = _nominates.fold(
            0,
            (previousValue, element) =>
                previousValue += element.isSelected ? 1 : 0);
        _buttonOpacity = selectedCount >= 1 ? 1.0 : 0.0;
      }),
      title: Text(
        custodian.username,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: FlatButton(
        onPressed: () => ExtendedNavigator.of(context).pushNamed(
          Routes.uciAccountDetails,
          arguments: custodian.uciAccount,
        ),
        child: custodian.isFetchingDetails
            ? LinearProgressIndicator()
            : Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Review >',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
      ),
    );
  }
}
