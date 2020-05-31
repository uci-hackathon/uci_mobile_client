import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../repository/repository.dart';
import '../../widgets.dart';

class ApplyForGrantPage extends StatefulWidget {
  @override
  _ApplyForGrantPageState createState() => _ApplyForGrantPageState();
}

class _ApplyForGrantModel {
  static const kAmount = 'amount';
  static const kTitle = 'title';
  static const kTeam = 'team';
  static const kWhy = 'why';
}

class _ApplyForGrantPageState extends State<ApplyForGrantPage> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final _loaderKey = GlobalKey<LoadingPlaceholderState>();
  var _buttonOpacity = 0.0;

  Future _onApplyGrantPressed(BuildContext context) async {
    final api = Provider.of<UciApi>(context, listen: false);
    final data = _fbKey.currentState.value;
    await api.submitGrant(Grant(
      amount: data[_ApplyForGrantModel.kAmount],
      title: data[_ApplyForGrantModel.kTitle],
      why: data[_ApplyForGrantModel.kWhy],
      team: data[_ApplyForGrantModel.kTeam],
    ));
    ExtendedNavigator.of(context).pop();
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
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: UciButton(
              onPressed: _buttonOpacity > 0.0
                  ? () => _loaderKey.currentState.load(
                        () => _onApplyGrantPressed(context),
                        successMessage: 'Grant submitted',
                        errorMessage: 'Not enough vote tokens',
                      )
                  : null,
              child: Text(
                'Apply',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: uciAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Text(
              'Apply for a grant',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            FormBuilder(
              onChanged: (_) => setState(
                () =>
                    _buttonOpacity = _fbKey.currentState.validate() ? 1.0 : 0.0,
              ),
              key: _fbKey,
              autovalidate: true,
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _ApplyForGrantModel.kAmount,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount *',
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ],
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _ApplyForGrantModel.kTitle,
          decoration: InputDecoration(
            labelText: 'Title of your work *',
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.max(70),
          ],
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _ApplyForGrantModel.kTeam,
          decoration: InputDecoration(
            labelText: 'Who will be the team',
          ),
          validators: [
            FormBuilderValidators.max(70),
          ],
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.black,
          autocorrect: false,
          attribute: _ApplyForGrantModel.kWhy,
          decoration: InputDecoration(
            labelText: 'How this grant will help you',
          ),
          validators: [
            FormBuilderValidators.max(70),
          ],
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
