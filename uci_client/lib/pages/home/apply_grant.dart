import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  var _buttonOpacity = 0.0;
  var _isApplyingForGrant = false;

  void _onApplyGrantPressed(BuildContext context) async {
    setState(() {
      _isApplyingForGrant = true;
    });

    try {
      ExtendedNavigator.of(context).pop();
    } catch (e) {
      print(e);
      if (e is Error) {
        print(e.stackTrace.toString());
      }
      setState(() {
        _isApplyingForGrant = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: _buttonOpacity,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: _isApplyingForGrant
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'This may take a while',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      LinearProgressIndicator(),
                    ],
                  ),
                )
              : RaisedButton(
                  onPressed: _buttonOpacity > 0.0
                      ? () => _onApplyGrantPressed(context)
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
              () => _buttonOpacity = _fbKey.currentState.validate() ? 1.0 : 0.0,
            ),
            key: _fbKey,
            autovalidate: true,
            child: _buildForm(),
          ),
        ],
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
