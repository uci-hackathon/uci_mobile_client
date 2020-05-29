import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';

import 'users.dart';

class NominatesPage extends StatefulWidget {
  @override
  _NominatesPageState createState() => _NominatesPageState();
}

class _NominatesPageState extends State<NominatesPage> {
  var _buttonOpacity = 0.0;
  var _isSubmitting = false;
  final _usersKey = GlobalKey<UsersState>();

  Future<List<String>> _fetchNominates() {
    final api = Provider.of<UciApi>(context, listen: false);
    return api.fetchNominates();
  }

  Future<List<String>> _fetchVoted() {
    final api = Provider.of<UciApi>(context, listen: false);
    return api.fetchVotedNominees();
  }

  void _submitVotes() async {
    setState(() {
      _isSubmitting = true;
    });

    await Provider.of<UciApi>(context, listen: false).submitVote(
      _usersKey.currentState.users
          .where((c) => c.isSelected)
          .map((e) => e.username)
          .toList(),
    );
    _usersKey.currentState.canVote = false;
    _usersKey.currentState.setState(() {});

    setState(() {
      _isSubmitting = false;
      _buttonOpacity = 0.0;
    });
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
          child: _isSubmitting
              ? LinearProgressIndicator()
              : RaisedButton(
                  onPressed: _buttonOpacity > 0.0 ? _submitVotes : null,
                  child: Text(
                    'Submit vote',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: UsersPage(
        title: Text(
          'Vote for 8 custodians',
          style: Theme.of(context).textTheme.headline4,
        ),
        votedUsers: _fetchVoted,
        fetchUsers: _fetchNominates,
        key: _usersKey,
        onVote: (users) {
          final selectedCount = users.fold(
            0,
            (previousValue, element) =>
                previousValue += element.isSelected ? 1 : 0,
          );
          _buttonOpacity = selectedCount >= 1 ? 1.0 : 0.0;
          setState(() {});
        },
      ),
    );
  }
}
