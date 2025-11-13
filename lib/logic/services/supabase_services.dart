import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/auth/sign_up_screen.dart';
import 'package:giver_receiver/presentation/screens/user_items_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  //////////////////////////////////////////////////////////////
  /////////             Future of signup              //////////
  //////////////////////////////////////////////////////////////
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: emailController.text,
      password: passController.text,
      // emailRedirectTo: 'autism://login-callback',
    );

    //if (!context.mounted) return;
    if (response.user != null) {
      print('Sign up successful');
    } else {
      print('Handle error');
    }
    return response;
  }

  ///////////////////////////////////////////////////////////////////
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      // محاولة تسجيل الدخول
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      // التأكد من وجود حساب
      final users = await supabase
          .from('users')
          .select()
          .eq('id', user!.id)
          .maybeSingle();

      if (users == null) {
        // الحساب مش موجود بجدول profiles
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يوجد حساب مرتبط بهذا البريد')),
        );
        _showSignUpDialog(context);
        return;
      }

      // ✅ نجاح تسجيل الدخول
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login succecfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserItems()),
      );
    } on AuthException catch (e) {
      // خطأ من Supabase
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      _showSignUpDialog(context);
    } catch (e) {
      // أي خطأ آخر
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ غير متوقع')));
      print('❌ Error: $e');
    }
  }

  //////////////////////////////////////////////////////////////
  /////////           _showSignUpDialog               //////////
  //////////////////////////////////////////////////////////////
  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Account not found"),
          // contentTextStyle: TextStyle(

          // ),
          content: Text(
            "You don\'t have an account yet. Do you want to sign up?",
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                Navigator.pop(ctx); // إغلاق الديالوج
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                Navigator.pop(ctx); // إغلاق الديالوج
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
                emailController.clear();
                passController.clear();
              },
              child: Text("Sign Up", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
