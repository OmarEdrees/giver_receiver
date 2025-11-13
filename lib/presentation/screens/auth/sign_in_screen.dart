import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:giver_receiver/logic/services/supabase_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/auth/sign_up_screen.dart';
import 'package:giver_receiver/presentation/screens/user_items_screen.dart';
import 'package:giver_receiver/presentation/widgets/auth/sign_up_in_SocialButton.dart';
import 'package:giver_receiver/presentation/widgets/customTextFields.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.04,
                vertical: SizeConfig.width * 0.07,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 77,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/logo_app1.png",
                          fit: BoxFit.contain,
                          height: SizeConfig.width * 0.6,
                        ),
                        // CircleAvatar(
                        //   backgroundColor: Colors.grey[200],
                        //   radius: 80,
                        //   //backgroundImage: AssetImage('assets/images/logo_app.jpeg'),
                        //   child: Icon(
                        //     Icons.camera_alt,
                        //     size: 40,
                        //     color: AppColors().primaryColor,
                        //   ),
                        // ),
                      ),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          letterSpacing: -0.5,
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sign in to continue',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 15),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              focusNode: emailFocus,
                              validator: emailValidator,
                              controller: emailController,
                              hintText: 'Enter Your Email',
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              focusNode: passFocus,
                              validator: passwordValidator,
                              controller: passController,
                              hintText: 'Enter Your Password',
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors().primaryColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Remmember me',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors().primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                if (_isLoading) return; // منع النقر المتكرر
                                if (_formKey.currentState!.validate()) {
                                  if (!mounted) return;
                                  setState(
                                    () => _isLoading = true,
                                  ); // تشغيل التحميل
                                  try {
                                    await SupabaseServices().signInUser(
                                      context: context,
                                      email: emailController.text,
                                      password: passController.text,
                                    );
                                  } catch (e) {
                                    // ❌ في حال حدوث خطأ
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
                                    setState(
                                      () => _isLoading = false,
                                    ); // إيقاف التحميل مهما كانت النتيجة
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
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey[350],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Or Continue with',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SocialButton(
                                  imagePath: 'assets/images/facebook.png',
                                  onTap: () {
                                    print("Facebook tapped");
                                  },
                                ),
                                SocialButton(
                                  imagePath: 'assets/images/google.png',
                                  onTap: () {
                                    print("Google tapped");
                                  },
                                ),

                                SocialButton(
                                  imagePath: 'assets/images/Twitter.png',
                                  onTap: () {
                                    print("Twitter tapped");
                                  },
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
                            "Don't have account?",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                            ),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                ' Sign up',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors().primaryColor,
                                ),
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
