import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';
import '../providers/auth_provider.dart';
import '../models/video.dart';
import '../services/firebase_service.dart';
import '../services/youtube_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _youtubeUrlController = TextEditingController();

  String? _selectedAthlete;
  String? _selectedVideoPath;
  bool _isUploading = false;
  String _uploadStatus = '';
  bool _useManualUrl = false;

  final YouTubeService _youtubeService = YouTubeService();

  // Mock athletes list - in real app, this would come from Firebase
  final List<String> _athletes = [
    'Sarah Ade',
    'John Smith',
    'Maria Garcia',
    'David Johnson',
    'Lisa Chen',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header/Navigation Bar
                Container(
                  color: const Color(0xFF1E293B),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.sm : AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      // Logo
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sprint',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textInverse,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Scope',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Navigation Links (hidden on mobile)
                      if (!isMobile) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard',
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            'Dashboard',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textInverse,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to settings
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            'Settings',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textInverse,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      // Coach Name/Profile Button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Show profile menu
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          child: Text(
                            'Coach Smith',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textInverse,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Mobile menu button
                      if (isMobile) ...[
                        const SizedBox(width: AppSpacing.sm),
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: AppColors.textInverse,
                            size: 20,
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

                // Main Content Area
                Container(
                  color: const Color(0xFFF8FAFC),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Section
                      Text(
                        'Upload New Sprint Video',
                        style: AppTextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Upload a video of your athlete\'s sprint for detailed analysis',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Upload Method Toggle
                      _buildUploadMethodToggle(),
                      const SizedBox(height: AppSpacing.lg),

                      // Upload Form
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Video Upload Area
                                  _buildVideoUploadArea(),
                                  const SizedBox(height: AppSpacing.xl),

                                  // Video Metadata Fields
                                  _buildMetadataFields(),
                                  const SizedBox(height: AppSpacing.xl),

                                  // Upload Status
                                  if (_uploadStatus.isNotEmpty) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                        AppSpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _uploadStatus.contains('Error')
                                                ? AppColors.error.withOpacity(
                                                  0.1,
                                                )
                                                : Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusSm,
                                        ),
                                        border: Border.all(
                                          color:
                                              _uploadStatus.contains('Error')
                                                  ? AppColors.error
                                                  : Colors.green,
                                        ),
                                      ),
                                      child: Text(
                                        _uploadStatus,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color:
                                                  _uploadStatus.contains(
                                                        'Error',
                                                      )
                                                      ? AppColors.error
                                                      : Colors.green,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                  ],

                                  // Submit Button
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusMd,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed:
                                          _isUploading ? null : _handleSubmit,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.lg,
                                          vertical: AppSpacing.md,
                                        ),
                                      ),
                                      child:
                                          _isUploading
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(AppColors.textInverse),
                                                ),
                                              )
                                              : Text(
                                                'Save and continue to analysis',
                                                style: AppTextStyles.labelLarge
                                                    .copyWith(
                                                      color:
                                                          AppColors.textInverse,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }

  Widget _buildUploadMethodToggle() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Method',
            style: AppTextStyles.labelLarge.copyWith(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _useManualUrl = false),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          !_useManualUrl
                              ? AppColors.warning.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color:
                            !_useManualUrl
                                ? AppColors.warning
                                : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color:
                              !_useManualUrl
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload File',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      !_useManualUrl
                                          ? AppColors.warning
                                          : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Upload video file directly',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _useManualUrl = true),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          _useManualUrl
                              ? AppColors.warning.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color:
                            _useManualUrl
                                ? AppColors.warning
                                : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link,
                          color:
                              _useManualUrl
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YouTube URL',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _useManualUrl
                                          ? AppColors.warning
                                          : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Paste YouTube video URL',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _useManualUrl ? 'YouTube Video URL' : 'Video File',
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        if (_useManualUrl) ...[
          // YouTube URL Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: TextFormField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                hintText: 'https://www.youtube.com/watch?v=...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSpacing.md),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: _showManualUploadInstructions,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a YouTube URL';
                }
                if (!_youtubeService.isValidYouTubeUrl(value.trim())) {
                  return 'Please enter a valid YouTube URL';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Paste the YouTube URL of your uploaded video',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ] else ...[
          // File Upload Area
          GestureDetector(
            onTap: _pickVideoFile,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color:
                      _selectedVideoPath != null
                          ? AppColors.warning
                          : const Color(0xFFCBD5E1),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child:
                  _selectedVideoPath != null
                      ? _buildSelectedVideoDisplay()
                      : _buildUploadPrompt(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Supports MP4, MOV, AVI up to 500MB',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder_open, size: 48, color: AppColors.warning),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Drag & Drop Video File Here',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Or click to browse your files',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedVideoDisplay() {
    final fileName = _selectedVideoPath!.split('/').last;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_file, size: 48, color: AppColors.warning),
          const SizedBox(height: AppSpacing.sm),
          Text(
            fileName,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _pickVideoFile,
            child: Text(
              'Change File',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Title
        _buildInputField(
          controller: _titleController,
          label: 'Video Title',
          placeholder: 'E.g., Sarah Ade - Final 100m',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a video title';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Select Athlete
        _buildDropdownField(),
        const SizedBox(height: AppSpacing.lg),

        // Video Date
        _buildInputField(
          controller: _dateController,
          label: 'Video Date',
          placeholder: 'mm/dd/yy',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the video date';
            }
            // Basic date validation
            if (!RegExp(r'^\d{2}/\d{2}/\d{2}$').hasMatch(value)) {
              return 'Please use mm/dd/yy format';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Notes
        _buildTextAreaField(),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
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

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Athlete',
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedAthlete,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            hint: Text(
              'Select an athlete',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            items:
                _athletes.map((athlete) {
                  return DropdownMenuItem(value: athlete, child: Text(athlete));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAthlete = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an athlete';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: AppTextStyles.labelLarge.copyWith(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextFormField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Any additional notes...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        allowedExtensions: ['mp4', 'mov', 'avi'],
      );

      if (result != null) {
        setState(() {
          _selectedVideoPath = result.files.single.path;
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error selecting file: $e';
      });
    }
  }

  void _showManualUploadInstructions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Manual Upload Instructions'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'To upload your video to YouTube:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '1. Go to YouTube Studio (https://studio.youtube.com)\n'
                    '2. Click "CREATE" > "Upload videos"\n'
                    '3. Select your video file\n'
                    '4. Set privacy to "Unlisted" (recommended)\n'
                    '5. Click "PUBLISH"\n'
                    '6. Copy the video URL and paste it above',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'This approach is free and doesn\'t require API setup.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_useManualUrl && _selectedVideoPath == null) {
      setState(() {
        _uploadStatus = 'Please select a video file';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus =
          _useManualUrl
              ? 'Saving video metadata...'
              : 'Uploading video to YouTube...';
    });

    try {
      String videoUrl;

      if (_useManualUrl) {
        // Use provided YouTube URL
        videoUrl = _youtubeUrlController.text.trim();
      } else {
        // Upload file to YouTube (simulated for now)
        await Future.delayed(const Duration(seconds: 3));
        videoUrl = 'https://www.youtube.com/watch?v=mock_video_id';
      }

      setState(() {
        _uploadStatus = 'Video uploaded successfully! Saving to database...';
      });

      // Save video metadata to Firebase
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user != null) {
        final video = Video(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          athleteName: _selectedAthlete!,
          event: '100m Sprint',
          uploadDate: _dateController.text.trim(),
          videoUrl: videoUrl,
          thumbnailUrl:
              _youtubeService.extractVideoId(videoUrl) != null
                  ? _youtubeService.getThumbnailUrl(
                    _youtubeService.extractVideoId(videoUrl)!,
                  )
                  : null,
          coachId: user.uid,
        );

        await FirebaseService().addVideo(video);

        setState(() {
          _uploadStatus =
              'Video saved successfully! Redirecting to dashboard...';
        });

        // Navigate to dashboard after successful upload
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error uploading video: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
