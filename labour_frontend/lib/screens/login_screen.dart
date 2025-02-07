// lib/screens/login_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Variables used in this file:
/// - _formKey: GlobalKey<FormState> used to uniquely identify the form and validate it.
/// - _emailController: TextEditingController used to control the email input field.
/// - _passwordController: TextEditingController used to control the password input field.
/// - _isLoading: bool used to track the loading state during the login API call.
/// - _apiService: ApiService instance used to handle API requests.
/// - _showLoader: bool used to determine whether the loader overlay should be shown or hidden.
/// - _loaderOpacity: double used to control the opacity of the loader overlay.


/// 🔐 LoginScreen: An animated login screen with API integration.
/// - Shows a full‑screen animated loader that fades out after 2 seconds.
/// - Reveals a login form with email and password fields.
/// - Performs API authentication and navigates to the dashboard upon success.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Form key for validation.
  final _formKey = GlobalKey<FormState>();
  // Controllers for email and password fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Flag to indicate login API call progress.
  bool _isLoading = false;
  // Instance of ApiService.
  final ApiService _apiService = ApiService();

  // Animation variables for the loader overlay.
  bool _showLoader = true;
  double _loaderOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    // Start the loader fade‑out after the splash duration.
    Future.delayed(AppDurations.splashDuration, () {
      setState(() {
        _loaderOpacity = 0.0;
      });
      Future.delayed(AppDurations.fadeDuration, () {
        setState(() {
          _showLoader = false;
        });
      });
    });
  }

  /// Handles the login process:
  /// - Validates the form.
  /// - Calls the API via ApiService.login.
  /// - Navigates to the dashboard on success.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Builds the login form.
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 📧 Email input field.
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Color(0xFFFFDC00), width: 2),
              ),
            ),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: AppSizes.paddingLarge),
          // 🔒 Password input field.
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Color(0xFFFFDC00), width: 2),
              ),
            ),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: AppSizes.paddingLarge),
          // ▶️ Login button.
          _isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.hovered)) {
                            return const Color(0xFF2ECC40); // Green on hover.
                          }
                          return AppColors.accentOrange;
                        },
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          // 🔗 "Create Account" button.
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }

  /// Builds an animated loader overlay.
  Widget _buildLoader() {
    return AnimatedOpacity(
      opacity: _loaderOpacity,
      duration: AppDurations.fadeDuration,
      child: Container(
        color: Colors.white,
        child: Center(
          child: LoaderWidget(vsync: this),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          // The login form.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 350),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildLoginForm(),
              ),
            ),
          ),
          // Loader overlay.
          if (_showLoader) _buildLoader(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

/// 🔄 LoaderWidget: Displays a rotating loader with a scaling and translating dot.
/// Replicates keyframe animations from the HTML/CSS reference.
class LoaderWidget extends StatefulWidget {
  final TickerProvider vsync;
  const LoaderWidget({super.key, required this.vsync});

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _dotScaleAnimation;
  late Animation<double> _dotTranslationAnimation;

  @override
  void initState() {
    super.initState();
    // Controller for a 2-second looping animation.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: widget.vsync,
    )..repeat();

    // 🔄 Rotation from 0 to 2π.
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    // 📏 Dot scale animation.
    _dotScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: ConstantTween(1.3), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_controller);

    // ↔️ Dot translation animation (teleports left by 30px).
    _dotTranslationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -30.0), weight: 1),
      TweenSequenceItem(tween: ConstantTween(-30.0), weight: 39),
      TweenSequenceItem(tween: Tween(begin: -30.0, end: 0.0), weight: 10),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Transform.translate(
                offset: Offset(_dotTranslationAnimation.value, 0),
                child: Transform.scale(
                  scale: _dotScaleAnimation.value,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.accentOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
