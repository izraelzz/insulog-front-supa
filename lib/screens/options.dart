import 'package:flutter/material.dart';
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await SavedLoginService().clearCredentials();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: MainBody(
        children: Center(
          child: SizedBox(
            width: size.width * 0.7,
            height: 52,
            child: CustomButtonWidget(
              text: 'Sair',
              textColor: Colors.white,
              onpressTextColor: Colors.white,
              bgColor: const Color(0xFF3EA75F),
              onpressBgColor: const Color(0xFF2F8A4D),
              borderRadius: BorderRadius.circular(12),
              isFontBold: true,
              onPressed: () => _logout(context),
            ),
          ),
        ),
      ),
    );
  }
}
