import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreenWidget extends StatelessWidget {
  final String title;
  final String body;
  final String image;

  const OnBoardingScreenWidget({
    super.key,
    required this.title,
    required this.body,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Lottie.asset(
                image,
                height: SizeConfig.height * 0.45,
                width: SizeConfig.height * 0.43,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.height * 0.065),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: -0.5,
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.height * 0.02),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.height * 0.065),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: steps.length,
                    effect: WormEffect(
                      activeDotColor: AppColors().primaryColor,
                      dotHeight: SizeConfig.height * 0.01,
                      dotWidth: SizeConfig.height * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
