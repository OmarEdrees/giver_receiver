import 'package:flutter/material.dart';
import 'package:giver_receiver/presentation/widgets/on_boarding/on_boarding_models.dart';

//////////////////////////////////////////////////////////////
///////            List of onboarding steps            ///////
//////////////////////////////////////////////////////////////
List<OnBoardingScreenWidget> steps = [
  OnBoardingScreenWidget(
    title: 'Welcome to "The Giver & The Receiver"',

    body:
        'Share the things you no longer need with others safely and privately.',
    image: "assets/lottie/Gift premium animation.json",
  ),
  OnBoardingScreenWidget(
    title: "Give What You Have",
    body:
        "Create a post for anything you want to give away, and let others see it anonymously.",
    image: "assets/lottie/Invite Friends or Share with Friends.json",
  ),
  OnBoardingScreenWidget(
    title: "Receive What You Need",
    body:
        "If someone wants what you shared, they can contact the admin to receive it—without revealing identities.",
    image: "assets/lottie/Let's chat!.json",
  ),
  OnBoardingScreenWidget(
    title: " Stay Private & Safe",
    body:
        "Your identity is never revealed. Share and receive items confidently.",
    image: "assets/lottie/Data Protection.json",
  ),
];

//////////////////////////////////////////////////////////////
/////         TextEditingController variables          ///////
//////////////////////////////////////////////////////////////
final PageController pageController = PageController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();
final TextEditingController fullNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController userNameController = TextEditingController();
final TextEditingController addItems = TextEditingController();

//////////////////////////////////////////////////////////////
//////////////         FocusNode            //////////////////
//////////////////////////////////////////////////////////////
final FocusNode emailFocus = FocusNode();
final FocusNode passFocus = FocusNode();
final FocusNode fullNameFocus = FocusNode();
final FocusNode phoneFocus = FocusNode();
final FocusNode userNameControllerFocus = FocusNode();
final FocusNode addItemsFocus = FocusNode();

//////////////////////////////////////////////////////////////
//////////////         validator            //////////////////
//////////////////////////////////////////////////////////////
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  // Regex للتحقق من صيغة الإيميل
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}

///////////////////////////////////////////////////////////////////
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }
  return null;
}

////////////////////////////////////////////////////////////
String? addChildNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the name';
  }
  if (value.length < 3) {
    return 'Name must be at least 3 characters long';
  }
  return null;
}

/////////////////////////////////////////////////////////////
String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter phone number';
  }
  // رقم الهاتف يجب أن يكون من 10 أرقام
  if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
    return 'Please enter a valid 11-digit phone number';
  }
  return null;
}

///////////////////////////////////////////////////////////////
String? validated(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please fill the field';
  }
  return null;
}

//////////////////////////////////////////////////////////////
///////////    ////////////       تحديد الوقت viewDoctorData
//////////////////////////////////////////////////////////////
String formatTime(String? dateTimeString) {
  if (dateTimeString == null) return '';

  final dateTime = DateTime.parse(dateTimeString).toUtc();
  final now = DateTime.now().toUtc(); // ✅ مقارنة بنفس التوقيت
  final difference = now.difference(dateTime);

  if (difference.inMinutes <= 0) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    final hours = (difference.inMinutes / 60).floor(); // ✅ أدق
    return '${hours}h ago';
  } else {
    return '${difference.inDays}d ago';
  }
}
