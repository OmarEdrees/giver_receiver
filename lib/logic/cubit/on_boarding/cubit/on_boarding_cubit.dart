import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class OnBoardingCubit extends Cubit<int> {
  OnBoardingCubit() : super(0);

  void changePage(int index) => emit(index);

  void nextPage(int currentIndex, int totalPages, PageController controller) {
    if (currentIndex < totalPages - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
