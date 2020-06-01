import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  static const kAvatar = 'avatar';
  static const kBio = 'bio';

  static const linksCount = 4;

  static Map<String, dynamic> toViewModel(UciAccount acc) {
    var viewModel = {
      _SignUpViewModel.kLinks + '1': 'test.com',
      _SignUpViewModel.kEmail: 'test@email.com',
      _SignUpViewModel.kBirthDate: DateTime.now(),
      _SignUpViewModel.kLastName: 'test',
      _SignUpViewModel.kFirstName: 'test',
    };

    if (acc != null) {
      viewModel = acc.toJson();
      viewModel.remove(_SignUpViewModel.kAvatar);

      viewModel[_SignUpViewModel.kBirthDate] =
          DateTime.tryParse(viewModel[_SignUpViewModel.kBirthDate]);

      final l = viewModel[_SignUpViewModel.kLinks] as List;
      var i = 0;
      l.forEach((element) {
        i++;
        viewModel[_SignUpViewModel.kLinks + i.toString()] = element;
      });
    }

    return viewModel;
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _fbKey = GlobalKey<FormBuilderState>();
  final _loaderKey = GlobalKey<LoadingPlaceholderState>();
  var _buttonOpacity = 0.0;
  var _isUsernameFree = true;

  bool get _isRegistered => _uciAccount != null;
  UciAccount _uciAccount;

  Map<String, dynamic> _initialValue;

  List<String> _transformLinks() {
    return List.generate(
      _SignUpViewModel.linksCount,
      (i) => (_fbKey.currentState
                  .value[_SignUpViewModel.kLinks + (i + 1).toString()] ??
              '')
          .toString(),
    ).where((l) => l.isNotEmpty).toList();
  }

  Future<String> _transformAvatar() async {
    final avatar = _fbKey.currentState.value[_SignUpViewModel.kAvatar];
    if (avatar == null || avatar.isEmpty) {
      return null;
    }

    File file = avatar.first;
    Uint8List bytes = await file.readAsBytes();
    final listBytes = await FlutterImageCompress.compressWithList(
      bytes.toList(),
      minHeight: 50,
      minWidth: 50,
      quality: 70,
      rotate: 135,
    );

    return base64Encode(listBytes);
  }

  Future _onCreateAccountPressed(BuildContext context) async {
    final api = Provider.of<UciApi>(context, listen: false);
    final value = _fbKey.currentState.value;
    value[_SignUpViewModel.kLinks] = _transformLinks();
    value[_SignUpViewModel.kAvatar] = await _transformAvatar();
    final acc = UciAccount.fromJson(value);

    if (_isRegistered) {
      _uciAccount = acc;
      await api.updateAccount(acc);
      return;
    }

    await api.createAccount(acc);
    ExtendedNavigator.of(context).pushNamed(
      Routes.homePage,
      arguments: ModalRoute.of(context).settings.arguments,
    );
  }

  @override
  void initState() {
    Future.microtask(() async {
      final api = Provider.of<UciApi>(context, listen: false);
      _uciAccount = await api.currentUciAccount();
      _initialValue = _SignUpViewModel.toViewModel(_uciAccount);
      print(_initialValue);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialValue == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
                        () => _onCreateAccountPressed(context),
                      )
                  : null,
              child: Text(
                !_isRegistered ? 'Create account' : 'Edit',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: UciAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            !_isRegistered
                ? Text(
                    'Registration',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : Row(
                    children: <Widget>[
                      UciAvatar(
                        image: _uciAccount.image,
                        username: _uciAccount.username,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Edit account\n${_uciAccount.username}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            FormBuilder(
              initialValue: _initialValue,
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
        Text(
          'Tell us a bit about you, the basics',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20),
        Theme(
          data: ThemeData(),
          child: FormBuilderImagePicker(
            validators: [
              FormBuilderValidators.max(1),
              FormBuilderValidators.maxLength(1),
            ],
            labelText: 'Avatar',
            attribute: _SignUpViewModel.kAvatar,
          ),
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
        _isRegistered
            ? Container()
            : FormBuilderTextField(
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
        FormBuilderTextField(
          cursorColor: Colors.black,
          autocorrect: false,
          attribute: _SignUpViewModel.kBio,
          decoration: InputDecoration(
            labelText: 'Bio',
          ),
          validators: [
            FormBuilderValidators.max(100),
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
