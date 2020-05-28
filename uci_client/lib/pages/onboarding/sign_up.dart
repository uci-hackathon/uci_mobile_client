import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uci_client/repository/repository.dart';

import '../../router.gr.dart';
import '../../widgets.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpViewModel {
  static const kFirstName = 'first_name';
  static const kLastName = 'last_name';
  static const kUsername = 'username';
  static const kBirthDate = 'birth_date';
  static const kEmail = 'email';
  static const kLinks = 'links';

  static const linksCount = 4;
}

class _SignUpPageState extends State<SignUpPage> {
  final _fbKey = GlobalKey<FormBuilderState>();
  var _buttonOpacity = 0.0;
  var _isUsernameFree = true;
  var _isCreatingAccount = false;

  void _onCreateAccountPressed(BuildContext context) async {
    setState(() {
      _isCreatingAccount = true;
    });

    try {
      final api = Provider.of<UciApi>(context, listen: false);
      final links = List.generate(
        _SignUpViewModel.linksCount,
        (i) => (_fbKey.currentState
                    .value[_SignUpViewModel.kLinks + (i + 1).toString()] ??
                '')
            .toString(),
      ).where((l) => l.isNotEmpty).toList();
      _fbKey.currentState.value[_SignUpViewModel.kLinks] = links;

      await api.createAccount(UciAccount.fromJson(_fbKey.currentState.value));
      ExtendedNavigator.of(context).pushNamed(Routes.homePage);
    } catch (e) {
      print(e);
      if (e is Error) {
        print(e.stackTrace.toString());
      }
      setState(() {
        _isCreatingAccount = false;
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
          child: _isCreatingAccount
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
                      ? () => _onCreateAccountPressed(context)
                      : null,
                  child: Text(
                    'Create account',
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
            'Registration',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 20),
          FormBuilder(
            initialValue: {
              _SignUpViewModel.kLinks + '1': 'test.com',
              _SignUpViewModel.kEmail: 'test@email.com',
              _SignUpViewModel.kBirthDate: DateTime.now(),
              _SignUpViewModel.kLastName: 'test',
              _SignUpViewModel.kFirstName: 'test',
            },
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
        Text(
          'Tell us a bit about you, the basics',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _SignUpViewModel.kFirstName,
          decoration: InputDecoration(
            labelText: 'First name *',
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
          attribute: _SignUpViewModel.kLastName,
          decoration: InputDecoration(
            labelText: 'Last name *',
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.max(70),
          ],
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          onChanged: (username) async {
            final u = username.toString();
            if (u.length != 12) {
              return;
            }

            try {
              await Provider.of<UciApi>(context, listen: false)
                  .fetchAccountByName(u);
              setState(() {
                _isUsernameFree = false;
              });
            } catch (e) {
              _isUsernameFree = true;
            }
          },
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _SignUpViewModel.kUsername,
          decoration: InputDecoration(
            labelText: 'Username (12 characters) *',
          ),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(12),
            FormBuilderValidators.maxLength(12),
            (_) => _isUsernameFree ? null : 'Username is taken',
          ],
        ),
        SizedBox(height: 20),
        Theme(
          data: ThemeData(
            inputDecorationTheme: Theme.of(context).inputDecorationTheme,
          ),
          child: FormBuilderDateTimePicker(
            cursorColor: Colors.black,
            attribute: _SignUpViewModel.kBirthDate,
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
            decoration: InputDecoration(
              labelText: 'Date of birth *',
            ),
            validators: [
              FormBuilderValidators.required(),
            ],
          ),
        ),
        SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _SignUpViewModel.kEmail,
          decoration: InputDecoration(
            labelText: 'Email *',
          ),
          keyboardType: TextInputType.emailAddress,
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Please share your online presence as a creator: instagram, youtube, vimeo, soundcloud etc.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20),
        ..._buildLinkFields(),
        SizedBox(height: 100),
      ],
    );
  }

  List<Widget> _buildLinkFields() {
    return List.generate(_SignUpViewModel.linksCount, (i) {
      i = i + 1;
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FormBuilderTextField(
          cursorColor: Colors.black,
          maxLines: 1,
          autocorrect: false,
          attribute: _SignUpViewModel.kLinks + i.toString(),
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: 'Link to your creative work $i ${i == 1 ? '*' : ''}',
          ),
          validators: [
            i == 1 ? FormBuilderValidators.required() : (_) => null,
            FormBuilderValidators.url(),
          ],
        ),
      );
    }).toList();
  }
}
