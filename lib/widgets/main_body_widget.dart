import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainBody extends StatelessWidget {
  final Widget children;

  const MainBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3EA75F),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Color.fromARGB(255, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: _bodyView(children: children),
    );
  }
}

class _bodyView extends StatelessWidget {
  final Widget children;

  const _bodyView({required this.children});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
       resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xFF3EA75F),
        child: Column(
          children: [
            SizedBox(
              height: topPadding + (size.height * 0.015),
              width: size.width,
            ),
            Expanded(
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.1),
                    topRight: Radius.circular(size.width * 0.1),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      blurRadius: 4,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
