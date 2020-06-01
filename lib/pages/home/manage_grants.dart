import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/models/grant.dart';
import 'package:uci_client/repository/repository.dart';
import 'package:uci_client/widgets.dart';

import 'account_router.gr.dart';
import 'users.dart';

class ManageGrantsPage extends StatefulWidget {
  @override
  _ManageGrantsPageState createState() => _ManageGrantsPageState();
}

class _ManageGrantsPageState extends State<ManageGrantsPage> {
  List<Grant> _grants;

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      _grants = await api.fetchGrants();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UciAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_grants == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (_grants.isEmpty) {
      return Center(
        child: Text(
          'No grants submitted',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: _grants.length,
      itemBuilder: (_, index) {
        final g = _grants[index];
        return ListTile(
          onTap: () => ExtendedNavigator.of(context).pushNamed(
            Routes.grantVotersPage,
            arguments: g.ballotName,
          ),
          title: Text(
            g.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            g.amountFormatted,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}

class GrantVotersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String ballotName = ModalRoute.of(context).settings.arguments;
    return UsersPage(
      title: Text(
        'Grant voters',
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline4,
      ),
      fetchUsers: () {
        final api = Provider.of<UciApi>(context, listen: false);
        return api.fetchVoters(ballotName);
      },
    );
  }
}
