import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignUp;

  const AuthScreen({super.key, this.isSignUp = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light gray background
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Logo
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sprint',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: const Color(0xFF1E293B), // Blue
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'Scope',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.warning, // Orange
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Title
                Text(
                  widget.isSignUp
                      ? 'Create your account'
                      : 'Log in to your account',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Auth Form
                Container(
                  width: isMobile ? double.infinity : 400,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _buildAuthForm(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthForm() {
    return Column(
      children: [
        // Form Fields
        if (widget.isSignUp) ...[
          // Full Name Field
          _buildInputField(
            label: 'Full Name',
            placeholder: 'Your Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Email Field
        _buildInputField(
          label: 'Email',
          placeholder: 'youremail@gmail.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Password Field
        _buildPasswordField(
          label: 'Password',
          placeholder: 'password',
          obscureText: _obscurePassword,
          onToggleVisibility:
              () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Confirm Password Field (Sign Up only)
        if (widget.isSignUp) ...[
          _buildPasswordField(
            label: 'Confirm Password',
            placeholder: 'password',
            obscureText: _obscureConfirmPassword,
            onToggleVisibility:
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Remember Me & Forgot Password
        Row(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged:
                      (value) => setState(() => _rememberMe = value ?? false),
                  activeColor: AppColors.warning,
                ),
                Text(
                  'Remember me',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (!widget.isSignUp)
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Submit Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: TextButton(
            onPressed: () {
              // Handle authentication
              if (widget.isSignUp) {
                // Handle sign up
                print('Sign up pressed');
              } else {
                // Handle log in
                print('Log in pressed');
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text(
              widget.isSignUp ? 'Sign in' : 'Log in',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Bottom Navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSignUp
                  ? 'Already have an account? '
                  : 'Don\'t have an account? ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AuthScreen(isSignUp: !widget.isSignUp),
                  ),
                );
              },
              child: Text(
                widget.isSignUp ? 'Login' : 'Sign up',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: const Color(0xFFFECACA),
            ), // Light pink border
          ),
          child: TextFormField(
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(icon, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String placeholder,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: const Color(0xFFFECACA),
            ), // Light pink border
          ),
          child: TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.textSecondary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
                onPressed: onToggleVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
