import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giver_receiver/logic/cubit/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/role_selection_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, int>(
        builder: (context, state) {
          var cubit = context.read<OnBoardingCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: SizeConfig.width * 0.05,
                      top: SizeConfig.width * 0.04,
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoleSelectionScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors().primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: steps.length,
                      onPageChanged: (index) {
                        cubit.changePage(index);
                      },
                      itemBuilder: (context, index) {
                        return steps[index];
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width * 0.04,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (state == steps.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoleSelectionScreen(),
                              ),
                            );
                          } else {
                            cubit.nextPage(state, steps.length, pageController);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.width * 0.04,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors().primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                letterSpacing: -0.2,
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
