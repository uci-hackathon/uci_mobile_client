import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WalkthroughPage extends StatelessWidget {
  Function onDone;

  WalkthroughPage({this.onDone});

  List<PageViewModel> _onboardingPages(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headline4.copyWith(
            fontFamily: 'FavoritStd',
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
    );

    return [
      PageViewModel(
        title: 'Universal Creator Income',
        body:
            'A Decentralised Autonomous Organisation (DAO) for the advancement of culture, where elected custodians curate the allocation of funds to foster creativity worldwide.',
        image: Center(
          child: Image.asset('assets/uci.png', height: 175.0),
        ),
        decoration: pageDecoration,
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
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _onboardingPages(context),
      done: const Text(
        'Done',
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
