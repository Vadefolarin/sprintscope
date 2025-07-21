import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildMobileDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header/Navigation Bar - Smaller
                Container(
                  color: const Color(0xFF1E293B), // Dark blue background
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.sm : AppSpacing.lg,
                    vertical: AppSpacing.sm, // Reduced from md to sm
                  ),
                  child: Row(
                    children: [
                      // Logo - Smaller
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sprint',
                              style: AppTextStyles.titleMedium.copyWith(
                                // Reduced from titleLarge
                                color: AppColors.textInverse,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Scope',
                              style: AppTextStyles.titleMedium.copyWith(
                                // Reduced from titleLarge
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Navigation Links (hidden on mobile) - Smaller
                      if (!isMobile) ...[
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            'Features',
                            style: AppTextStyles.bodySmall.copyWith(
                              // Reduced from bodyMedium
                              color: AppColors.textInverse,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm), // Reduced from md
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            'About',
                            style: AppTextStyles.bodySmall.copyWith(
                              // Reduced from bodyMedium
                              color: AppColors.textInverse,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm), // Reduced from md
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            'Contact',
                            style: AppTextStyles.bodySmall.copyWith(
                              // Reduced from bodyMedium
                              color: AppColors.textInverse,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm), // Reduced from md
                      ],
                      // Sign in Button - Smaller
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/auth',
                              arguments: {'isSignUp': false},
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          child: Text(
                            'Sign in',
                            style: AppTextStyles.bodySmall.copyWith(
                              // Reduced from bodyMedium
                              color: AppColors.textInverse,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Mobile menu button - Smaller
                      if (isMobile) ...[
                        const SizedBox(width: AppSpacing.sm), // Reduced from md
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: AppColors.textInverse,
                            size: 20, // Reduced size
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Hero Section
                Container(
                  color: const Color(0xFFF8FAFC), // Light gray background
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child:
                      isMobile
                          ? _buildMobileHero(context)
                          : _buildDesktopHero(context),
                ),

                // How It Works Section
                Container(
                  color: const Color(0xFFF8FAFC), // Light gray background
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HowItWorksStep(
                        number: 1,
                        title: 'Upload Sprint Videos',
                        description:
                            'Easily upload videos of your athletes\' 100m sprints for detailed analysis. Our system supports all common video formats.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _HowItWorksStep(
                        number: 2,
                        title: 'Analyze Frame by Frame',
                        description:
                            'Break down every aspect of sprint technique with our frame-by-frame analysis tools. Focus on posture, arm movement, foot placement, and more.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _HowItWorksStep(
                        number: 3,
                        title: 'Compare & Improve',
                        description:
                            'Compare your athlete\'s technique with professional sprinters, track improvements over time, and provide detailed feedback directly on the video.',
                      ),
                    ],
                  ),
                ),

                // Testimonials Section
                Container(
                  color: const Color(0xFFF8FAFC), // Light gray background
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Trusted by Thousand of Coaches',
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      isMobile
                          ? _buildMobileTestimonials()
                          : _buildDesktopTestimonials(),
                    ],
                  ),
                ),

                // CTA Section
                Stack(
                  children: [
                    // Background Image
                    SizedBox(
                      width: double.infinity,
                      height: isMobile ? 300 : 400,
                      child: Image.asset(
                        'assets/images/footer.png',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: AppColors.surfaceVariant,
                              child: const Center(
                                child: Icon(Icons.image, size: 64),
                              ),
                            ),
                      ),
                    ),
                    // Dark Overlay
                    Container(
                      width: double.infinity,
                      height: isMobile ? 300 : 400,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    // Content
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                isMobile ? AppSpacing.md : AppSpacing.xl,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ready to Get Started?',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Join thousands of satisfied coaches and take your training to the next level',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textInverse,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/auth',
                                      arguments: {'isSignUp': true},
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg,
                                      vertical: AppSpacing.md,
                                    ),
                                  ),
                                  child: Text(
                                    'Get Started',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.textInverse,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Footer
                Container(
                  color: const Color(0xFF1E293B), // Dark blue background
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Main Footer Content
                      isMobile ? _buildMobileFooter() : _buildDesktopFooter(),
                      const SizedBox(height: AppSpacing.lg),
                      // Separator Line
                      const Divider(color: Color(0xFF64748B)),
                      const SizedBox(height: AppSpacing.md),
                      // Copyright
                      Text(
                        '© 2023 SprintScope. All rights reserved.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textInverse,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column - Text and Buttons
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analyze Sprint Techniques like never before',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'SprintScope gives coaches the tools to analyze, annotate, and improve athlete performance with frame-by-frame video analysis for 100m sprints.',
                style: AppTextStyles.bodyLargeSecondary.copyWith(
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/auth',
                          arguments: {'isSignUp': true},
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF64748B),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: Text(
                        'Upload Video',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        // Right Column - Image
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Image.asset(
              'assets/images/desktop_landing_page.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 400,
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text('Hero Image Placeholder'),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analyze Sprint Techniques like never before',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B), // Dark blue text
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'SprintScope gives coaches the tools to analyze, annotate, and improve athlete performance with frame-by-frame video analysis for 100m sprints.',
          style: AppTextStyles.bodyLargeSecondary.copyWith(
            color: const Color(0xFF64748B), // Lighter gray text
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/auth',
                arguments: {'isSignUp': true},
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text(
              'Get Started',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Image.asset(
            'assets/images/mobile_landing.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text('Hero Image'),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTestimonials() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _TestimonialCard(
                quote:
                    "This platform has transformed how we work, the features are exactly when we need",
                name: "Sarah Johnson",
                role: "Coach at melbourne university",
              ),
              const SizedBox(height: AppSpacing.lg),
              _TestimonialCard(
                quote:
                    "I love the intuitive design, it makes collaboration so much easier",
                name: "Michael Lee",
                role: "Product Manager at Tech Innovations",
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            children: [
              _TestimonialCard(
                quote:
                    "The analytics tools provided insightful data that improved our decision-making",
                name: "Emily Carter",
                role: "Data Analyst at Market insights",
              ),
              const SizedBox(height: AppSpacing.lg),
              _TestimonialCard(
                quote:
                    "Seamless integration with other tools has boosted our productivity tremendously",
                name: "David Kim",
                role: "Operations Director at Creative Solutions",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTestimonials() {
    return Column(
      children: [
        _TestimonialCard(
          quote:
              "This platform has transformed how we work, the features are exactly when we need",
          name: "Sarah Johnson",
          role: "Coach at melbourne university",
        ),
        const SizedBox(height: AppSpacing.md),
        _TestimonialCard(
          quote:
              "The analytics tools provided insightful data that improved our decision-making",
          name: "Emily Carter",
          role: "Data Analyst at Market insights",
        ),
        const SizedBox(height: AppSpacing.md),
        _TestimonialCard(
          quote:
              "I love the intuitive design, it makes collaboration so much easier",
          name: "Michael Lee",
          role: "Product Manager at Tech Innovations",
        ),
        const SizedBox(height: AppSpacing.md),
        _TestimonialCard(
          quote:
              "Seamless integration with other tools has boosted our productivity tremendously",
          name: "David Kim",
          role: "Operations Director at Creative Solutions",
        ),
      ],
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Sprint',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textInverse,
                ),
              ),
              TextSpan(
                text: 'Scope',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Navigation Links
        _buildFooterColumn('Product', [
          'Features',
          'Get started',
          'Case studies',
          'Reviews',
        ]),
        const SizedBox(width: AppSpacing.xl),
        _buildFooterColumn('Company', ['About us', 'Careers', 'Press', 'Blog']),
        const SizedBox(width: AppSpacing.xl),
        _buildFooterColumn('Support', [
          'Contact us',
          'Help center',
          'Privacy policy',
          'Terms of service',
        ]),
        const SizedBox(width: AppSpacing.xl),
        // Social Media Icons
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.facebook,
                    color: AppColors.textInverse,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.flutter_dash,
                    color: AppColors.textInverse,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt,
                    color: AppColors.textInverse,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.link,
                    color: AppColors.textInverse,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Sprint',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textInverse,
                ),
              ),
              TextSpan(
                text: 'Scope',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Navigation Links
        Row(
          children: [
            Expanded(
              child: _buildFooterColumn('Product', [
                'Features',
                'Get started',
                'Case studies',
                'Reviews',
              ]),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildFooterColumn('Company', [
                'About us',
                'Careers',
                'Press',
                'Blog',
              ]),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildFooterColumn('Support', [
                'Contact us',
                'Help center',
                'Privacy policy',
                'Terms of service',
              ]),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Social Media Icons
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.facebook,
                color: AppColors.textInverse,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.flutter_dash,
                color: AppColors.textInverse,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt,
                color: AppColors.textInverse,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.link,
                color: AppColors.textInverse,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                link,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textInverse,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E293B), // Dark blue background
      child: Column(
        children: [
          // Header with logo
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sprint',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textInverse,
                        ),
                      ),
                      TextSpan(
                        text: 'Scope',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textInverse),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Navigation Links - Centered
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home Link
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Text(
                    'Home',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textInverse,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Dashboard Link
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Text(
                    'Dashboard',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textInverse,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons at Bottom
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Sign in Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/auth',
                        arguments: {'isSignUp': false},
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Sign in',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Log in Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/auth',
                        arguments: {'isSignUp': false},
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Log in',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Icon
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B), // Dark blue circle
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyles.bodyMediumSecondary.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String name;
  final String role;

  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quote, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(role, style: AppTextStyles.bodySmallSecondary),
        ],
      ),
    );
  }
}
