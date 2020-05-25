import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../repository/models/models.dart';
import '../router.gr.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var _pageIndex = 0;

  final _onboardingPages = [
    PageViewModel(
      title: '',
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
        child: Image.network("https://domaine.com/image.png", height: 175.0),
      ),
    ),
    PageViewModel(
      title: "Title of first page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
        child: Image.network("https://domaine.com/image.png", height: 175.0),
      ),
    ),
    PageViewModel(
      title: "Title of first page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
        child: Image.network("https://domaine.com/image.png", height: 175.0),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: <Widget>[
          _landingScreen(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Who are you?',
                style: Theme.of(context).textTheme.headline4,
              ),
              _buildButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _landingScreen() {
    return IntroductionScreen(
      pages: _onboardingPages,
      done: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: () {},
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).accentColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
        children: AccountType.values
            .map((e) => RaisedButton(
                  onPressed: () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.homePage,
                    arguments: e,
                  ),
                  child: Text(
                    e.toString().split('.').last.toUpperCase(),
                  ),
                ))
            .toList());
  }
}
