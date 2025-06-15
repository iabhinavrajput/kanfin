import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'login_form.dart';
import 'signup_form.dart';

class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: ContainedTabBarView(
          tabs: const [
            Text('Log in',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('Sign up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
          views: [
            LoginForm(),
            SignupScreen(),
          ],
          tabBarProperties: TabBarProperties(
            indicatorColor: AppColors.royalBlue,
            labelColor: AppColors.royalBlue,
            unselectedLabelColor: Colors.grey,
            alignment: TabBarAlignment.center,
            indicatorWeight: 2.5,
            labelPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
      ),
    );
  }
}
