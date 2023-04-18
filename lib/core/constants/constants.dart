import 'package:flutter/material.dart';

class Constants {
  static const loginScreenImage = 'assets/images/loginScreen.png';

  static const avatarDefault =
      'https://images.pexels.com/photos/16248676/pexels-photo-16248676.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  static const bannerDefault =
      'https://images.pexels.com/photos/16248676/pexels-photo-16248676.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
