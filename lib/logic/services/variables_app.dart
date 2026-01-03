import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giver_receiver/presentation/widgets/Donor/bottom_navigation_bar_donor.dart';
import 'package:giver_receiver/presentation/widgets/Recipient/bottom_navigation_bar_recipient.dart';
import 'package:giver_receiver/presentation/widgets/on_boarding/on_boarding_models.dart';
import 'package:image_picker/image_picker.dart';

//////////////////////////////////////////////////////////////
///////            List of onboarding steps            ///////
//////////////////////////////////////////////////////////////
List<OnBoardingScreenWidget> steps = [
  OnBoardingScreenWidget(
    title: 'مرحبا بكم في "الواهب & الموهوب"',
    body: 'شارك الأشياء التي لم تعد بحاجة إليها مع الآخرين بأمان وبشكل خاص.',
    image: "assets/lottie/Gift premium animation.json",
  ),

  OnBoardingScreenWidget(
    title: "أعط ما لديك",
    body: "أنشئ منشورًا لأي شيء تريد التخلي عنه، ودع الآخرين يرونه بشكل مجهول.",
    image: "assets/lottie/Invite Friends or Share with Friends.json",
  ),

  OnBoardingScreenWidget(
    title: "احصل على ما تحتاجه",
    body:
        "إذا كان شخص ما مهتمًا بما شاركته، فيمكنه الاتصال بالمسؤول لاستلامه - دون الكشف عن هويته.",
    image: "assets/lottie/Let's chat!.json",
  ),

  OnBoardingScreenWidget(
    title: "ابق خاصًا وآمنًا",
    body: "لم يتم الكشف عن هويتك أبدا. شارك واستقبل العناصر بثقة.",
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
final TextEditingController addItemsTitle = TextEditingController();
final TextEditingController addItemsDescription = TextEditingController();
final TextEditingController addItemsQuantity = TextEditingController();
final PageController pageControllerImages = PageController();
late PageController pageControllerImagesItems;
late PageController pageControllerImagesMyItems;
final TextEditingController editeProfileName = TextEditingController();
final TextEditingController editProfileEmail = TextEditingController();
final TextEditingController editProfilePhone = TextEditingController();
final TextEditingController itemScreenSearch = TextEditingController();
final TextEditingController myItemScreenSearch = TextEditingController();
final TextEditingController saveScreenSearch = TextEditingController();
final TextEditingController reasonController = TextEditingController();
final TextEditingController requestScreenSearch = TextEditingController();

//////////////////////////////////////////////////////////////
//////////////         FocusNode            //////////////////
//////////////////////////////////////////////////////////////
final FocusNode emailFocus = FocusNode();
final FocusNode passFocus = FocusNode();
final FocusNode fullNameFocus = FocusNode();
final FocusNode phoneFocus = FocusNode();
final FocusNode userNameControllerFocus = FocusNode();
final FocusNode addItemsTitleFocus = FocusNode();
final FocusNode addItemsDescriptionFocus = FocusNode();
final FocusNode addItemsQuantityFocus = FocusNode();
final FocusNode editProfileNameFocus = FocusNode();
final FocusNode editProfileEmailFocus = FocusNode();
final FocusNode editProfilePhoneFocus = FocusNode();
final FocusNode itemScreenSearchFocus = FocusNode();

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
    return 'now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    final hours = (difference.inMinutes / 60).floor();
    return '${hours}h ago';
  } else {
    return '${difference.inDays}d ago';
  }
}

//////////////////////////////////////////////////////////////
/////             select doctor or parent              ///////
//////////////////////////////////////////////////////////////
String userRole = '';

void onSignUpSuccess(BuildContext context) {
  if (userRole == 'الواهب') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainBottomNavDonor()),
    );
    print(userRole);
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainBottomNavRecipient()),
    );
  }
}

//////////////////////////////////////////////////////////////
/////              select image variables              ///////
//////////////////////////////////////////////////////////////
final ImagePicker picker = ImagePicker();
File? selectedImage;
