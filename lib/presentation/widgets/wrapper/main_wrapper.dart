import 'package:flutter/material.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const MainWrapper({
    super.key,
    required this.child,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/images/background/background.webp",
              width: .infinity,
              height: .infinity,
              fit: .fill,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
