import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sign_up_services/save_profile_user_data.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:giver_receiver/logic/services/supabase_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/auth/sign_in_screen.dart';
import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final saveUserData = SaveProfileUserData();
  File? _selectedImage;
  final _picker = ImagePicker();

  ////////////////////////////////////////////////////
  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.width * 0.04,
                left: SizeConfig.width * 0.04,
                bottom: SizeConfig.width * 0.07,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 55,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: AppColors().primaryColor,
                            radius: 70,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            child: _selectedImage == null
                                ? const Icon(Icons.camera_alt, size: 40)
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      Text(
                        'Sign Up!',
                        style: TextStyle(
                          letterSpacing: -0.5,
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Create a new account',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              focusNode: userNameControllerFocus,
                              validator: addChildNameValidator,
                              controller: userNameController,
                              hintText: 'Enter username',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 10),

                            CustomTextFormField(
                              focusNode: fullNameFocus,
                              validator: addChildNameValidator,
                              controller: fullNameController,
                              hintText: 'Enter full name',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 10),

                            CustomTextFormField(
                              focusNode: emailFocus,
                              validator: emailValidator,
                              controller: emailController,
                              hintText: 'Enter your email',
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 10),

                            CustomTextFormField(
                              focusNode: passFocus,
                              validator: passwordValidator,
                              controller: passController,
                              hintText: 'Enter your password',
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            const SizedBox(height: 10),

                            CustomTextFormField(
                              keyboardType: TextInputType.number,
                              focusNode: phoneFocus,
                              validator: phoneValidator,
                              controller: phoneController,
                              hintText: 'Enter phone number',
                              icon: Icons.phone,
                            ),
                            SizedBox(height: 15),

                            GestureDetector(
                              onTap: () async {
                                if (_isLoading) return;
                                if (_formKey.currentState!.validate()) {
                                  if (!mounted) return;
                                  setState(() => _isLoading = true);

                                  try {
                                    final authResponse =
                                        await SupabaseServices().signUp(
                                          context,
                                          emailController.text.trim(),
                                          passController.text.trim(),
                                        );

                                    final user = authResponse.user;
                                    if (!context.mounted) return;

                                    if (user != null) {
                                      await saveUserData.saveUserData(
                                        context: context,
                                        formKey: _formKey,
                                        id: user.id,
                                        username: userNameController.text
                                            .trim(),
                                        email: emailController.text.trim(),
                                        fullName: fullNameController.text
                                            .trim(),
                                        phone: phoneController.text.trim(),
                                        imageFile: _selectedImage,
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignInScreen(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('❌ Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } finally {
                                    if (!mounted) return;
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },

                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors().primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              'By continuing, you agree to the following:',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors().primaryColor,
                                  ),
                                ),
                                Text(
                                  ' without reservation',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' Sign In',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors().primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
