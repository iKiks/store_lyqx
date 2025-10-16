import 'package:store_lyqx/lyqx_core.dart';
import 'package:flutter/material.dart';

class RootShell extends StatefulWidget {
  final Widget child;
  const RootShell({super.key, required this.child});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  void _onTap(int idx) {
    setState(() => _currentIndex = idx);
    switch (idx) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/wishlist');
        break;
      case 2:
        GoRouter.of(context).go('/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        color: AppColors.whiteColor,
        child: SafeArea(
          top: false,
          child: SizedBox(
            // Taller bar for centered icons
            height: ResponsiveSize.height(56),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: _onTap,
              iconSize: ResponsiveSize.height(24),
              selectedFontSize: 0,
              unselectedFontSize: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: ResponsiveSize.height(0)),
                    child: Icon(
                      Icons.home_outlined,
                      size: ResponsiveSize.height(26),
                      color: _currentIndex == 0
                          ? AppColors.primaryColor
                          : AppColors.extraLightColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: ResponsiveSize.height(0)),
                    child: Icon(
                      Icons.favorite_border,
                      size: ResponsiveSize.height(26),
                      color: _currentIndex == 1
                          ? AppColors.primaryColor
                          : AppColors.extraLightColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: ResponsiveSize.height(0)),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: ResponsiveSize.height(26),
                      color: _currentIndex == 2
                          ? AppColors.primaryColor
                          : AppColors.extraLightColor,
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
