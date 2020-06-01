import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';

import '../../widgets.dart';
import 'vote_router.gr.dart';

typedef UserFetcher = Future<List<String>> Function();
typedef OnVote = void Function(List<_UserViewModel>);

class UsersPage extends StatefulWidget {
  final UserFetcher fetchUsers;
  final UserFetcher votedUsers;
  final Key key;
  final OnVote onVote;
  final Widget title;

  UsersPage({
    this.votedUsers,
    this.fetchUsers,
    this.onVote,
    this.key,
    this.title,
  }) : super(key: key);

  @override
  UsersState createState() => UsersState();
}

class _UserViewModel {
  _UserViewModel({this.username});

  String username;
  UciAccount uciAccount;
  var isSelected = false;

  bool get isFetchingDetails => uciAccount == null;
}

class UsersState extends State<UsersPage> {
  List<_UserViewModel> users;
  var canVote = true;

  @override
  void initState() {
    Future.microtask(() async {
      final usernames = await widget.fetchUsers();
      users = usernames.map((e) => _UserViewModel(username: e)).toList();
      setState(() {});

      final api = Provider.of<UciApi>(context, listen: false);
      users.forEach((c) async {
        c.uciAccount = await api.fetchMetadata(c.username);
        setState(() {});
      });

      if (widget.votedUsers != null) {
        final voted = await widget.votedUsers();
        canVote = voted.isEmpty;

        users
            .where((u) => voted.indexWhere((e) => u.username == e) >= 0)
            .forEach((u) {
          u.isSelected = true;
        });

        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UciAppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(20),
            child: widget.title,
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (users == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Text(
          'Empty',
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(left: 5),
      itemCount: users.length,
      itemBuilder: (_, index) => _buildUserTile(
        users[index],
      ),
    );
  }

  Widget _buildUserTile(_UserViewModel user) {
    if (widget.onVote == null) {
      return ListTile(
        title: _buildUserTitle(user),
        subtitle: _buildUserSubtitle(user),
      );
    }

    return CheckboxListTile(
      isThreeLine: true,
      value: user.isSelected,
      onChanged: (val) {
        if (canVote) {
          setState(() {
            user.isSelected = val;
          });
          Future.microtask(() => widget.onVote(users));
        }
      },
      title: _buildUserTitle(user),
      subtitle: _buildUserSubtitle(user),
    );
  }

  Widget _buildUserSubtitle(_UserViewModel user) {
    return Transform.translate(
      offset: Offset(-15, 0),
      child: FlatButton(
        onPressed: () => ExtendedNavigator.of(context).pushNamed(
          Routes.uciAccountDetails,
          arguments: user.uciAccount,
        ),
        child: user.isFetchingDetails
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

  Widget _buildUserTitle(_UserViewModel user) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: UciAvatar(
            image: user.uciAccount?.image,
            username: user.username,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            user.isFetchingDetails
                ? Container()
                : Text(
                    user.uciAccount.firstName + ' ' + user.uciAccount.lastName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
            Text(
              '@${user.username}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }
}
