import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/splash_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: ResponsiveSize.height(448)),
                Image(image: AssetImage('assets/branding.png')),
                SizedBox(height: ResponsiveSize.height(18)),
                AppTexts(
                  'Fake Store',
                  fontSize: ResponsiveSize.fontSize(28),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: ResponsiveSize.height(40)),
                AppButtons(
                  buttonText: 'Login',
                  onPressed: () {
                    context.pushNamed('login');
                  },
                  buttonColor: AppColors.primaryColor,
                  textColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
