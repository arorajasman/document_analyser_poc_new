import 'dart:math';

import 'package:document_analyser_poc_new/services/signalling_service.dart';
import 'package:document_analyser_poc_new/utils/app_colors.dart';
import 'package:document_analyser_poc_new/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  final String websocketUrl =
      "https://13eb-103-119-166-144.ngrok-free.app/signalling-server";

  void _loginButtonOnPressedHandler() {
    context.go("/dashboard");
  }

  void _initSignalingService() {
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );
  }

  void _storeCallerId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("callerID", selfCallerID);
    _initSignalingService();
  }

  @override
  void initState() {
    print('init is called..');
    _storeCallerId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue800,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.black26,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: AppColors.grey800,
              ), // Icon at the top
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: AppStrings.username,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text(AppStrings.rememberMe),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _loginButtonOnPressedHandler,
                    child: const Text(AppStrings.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
