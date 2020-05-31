import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';

import '../../widgets.dart';
import 'users.dart';

class NominatesPage extends StatefulWidget {
  @override
  _NominatesPageState createState() => _NominatesPageState();
}

class _NominatesPageState extends State<NominatesPage> {
  var _buttonOpacity = 0.0;
  var _isSubmitted = false;
  final _usersKey = GlobalKey<UsersState>();
  final _loaderKey = GlobalKey<LoadingPlaceholderState>();

  Future<List<String>> _fetchNominates() {
    final api = Provider.of<UciApi>(context, listen: false);
    return api.fetchCurrentNominates();
  }

  Future<List<String>> _fetchVoted() async {
    final api = Provider.of<UciApi>(context, listen: false);
    final voted = await api.fetchVotedNominees();
    setState(() {
      _isSubmitted = voted.isNotEmpty;
    });
    return voted;
  }

  Future _submitVotes() async {
    final api = Provider.of<UciApi>(context, listen: false);

    await api.submitVote(
      _usersKey.currentState.users
          .where((c) => c.isSelected)
          .map((e) => e.username)
          .toList(),
    );
    _usersKey.currentState.canVote = false;
    _usersKey.currentState.setState(() {});

    setState(() {
      _buttonOpacity = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPlaceholder(
      key: _loaderKey,
      child: Scaffold(
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 400),
          opacity: _buttonOpacity,
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: UciButton(
              onPressed: _buttonOpacity > 0.0
                  ? () => _loaderKey.currentState.load(
                        _submitVotes,
                        successMessage: 'Vote submitted',
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
        body: UsersPage(
          title: Text(
            _isSubmitted ? 'Already voted' : 'Vote for 8 custodians',
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
      ),
    );
  }
}
