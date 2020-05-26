import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WalkthroughPage extends StatelessWidget {
  Function onDone;

  WalkthroughPage({this.onDone});

  List<PageViewModel> _onboardingPages(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headline4,
    );

    return [
      PageViewModel(
        title: 'Universal Creator Income',
        body:
            'An alternative economic infrastructure to fund creators who produce the beauty in our world.',
        image: Center(
          child: Image.asset('assets/onboard1.png', height: 175.0),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'Empowering creators worldwide',
        body:
            'Creativity is key to advancement of humanity and we need to foster innovation across borders.',
        image: Center(
          child: Image.asset('assets/onboard2.png', height: 175.0),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: 'A Decentralized Organization',
        body:
            'Neutrality and transparency in governance to offer more fair and distributed forms of curation.',
        image: Center(
          child: Image.asset('assets/onboard3.png', height: 175.0),
        ),
        decoration: pageDecoration,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _onboardingPages(context),
      done: const Text(
        'Start',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: onDone,
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
}
