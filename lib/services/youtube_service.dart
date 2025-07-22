import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  // YouTube Data API v3 configuration
  static const String _apiKey =
      'YOUR_YOUTUBE_API_KEY'; // You'll need to get this from Google Cloud Console
  static const String _clientId = 'YOUR_CLIENT_ID';
  static const String _clientSecret = 'YOUR_CLIENT_SECRET';

  // YouTube OAuth 2.0 endpoints
  static const String _authUrl = 'https://accounts.google.com/o/oauth2/auth';
  static const String _tokenUrl = 'https://oauth2.googleapis.com/token';
  static const String _uploadUrl =
      'https://www.googleapis.com/upload/youtube/v3/videos';

  /// Upload video to YouTube and return the video URL
  /// This is a simplified implementation - you'll need to implement OAuth 2.0 flow
  Future<String?> uploadVideo({
    required File videoFile,
    required String title,
    required String description,
    List<String> tags = const [],
    String privacyStatus = 'unlisted', // 'public', 'private', 'unlisted'
  }) async {
    try {
      // Step 1: Get OAuth 2.0 access token (you'll need to implement this)
      String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception('Failed to get access token');
      }

      // Step 2: Upload video to YouTube
      final response = await _uploadToYouTube(
        videoFile: videoFile,
        title: title,
        description: description,
        tags: tags,
        privacyStatus: privacyStatus,
        accessToken: accessToken,
      );

      if (response != null) {
        final videoId = response['id'];
        return 'https://www.youtube.com/watch?v=$videoId';
      }

      return null;
    } catch (e) {
      throw Exception('Failed to upload video to YouTube: $e');
    }
  }

  /// Get OAuth 2.0 access token
  /// This is a placeholder - you'll need to implement the full OAuth flow
  Future<String?> _getAccessToken() async {
    // TODO: Implement OAuth 2.0 flow
    // 1. Redirect user to Google OAuth consent screen
    // 2. Get authorization code
    // 3. Exchange authorization code for access token
    // 4. Store and refresh tokens as needed

    // For now, return null to indicate this needs to be implemented
    return null;
  }

  /// Upload video file to YouTube
  Future<Map<String, dynamic>?> _uploadToYouTube({
    required File videoFile,
    required String title,
    required String description,
    required List<String> tags,
    required String privacyStatus,
    required String accessToken,
  }) async {
    try {
      // Prepare the video metadata
      final metadata = {
        'snippet': {
          'title': title,
          'description': description,
          'tags': tags,
          'categoryId': '17', // Sports category
        },
        'status': {'privacyStatus': privacyStatus},
      };

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_uploadUrl?part=snippet,status&uploadType=multipart'),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add video file
      final videoStream = http.ByteStream(videoFile.openRead());
      final videoLength = await videoFile.length();
      final multipartFile = http.MultipartFile(
        'video',
        videoStream,
        videoLength,
        filename: videoFile.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add metadata
      request.fields['metadata'] = jsonEncode(metadata);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Upload failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to upload to YouTube: $e');
    }
  }

  /// Alternative: Manual upload flow
  /// This method provides instructions for manual upload
  Future<String> getManualUploadInstructions({
    required String title,
    required String description,
  }) async {
    // Return instructions for manual upload
    return '''
Manual Upload Instructions:

1. Go to YouTube Studio (https://studio.youtube.com)
2. Click "CREATE" > "Upload videos"
3. Select your video file
4. Set the following details:
   - Title: $title
   - Description: $description
   - Privacy: Unlisted (recommended for analysis)
   - Category: Sports
5. Click "PUBLISH"
6. Copy the video URL and paste it below

Note: This approach doesn't require API setup and is free to use.
    ''';
  }

  /// Validate YouTube URL
  bool isValidYouTubeUrl(String url) {
    final regex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );
    return regex.hasMatch(url);
  }

  /// Extract video ID from YouTube URL
  String? extractVideoId(String url) {
    final regex = RegExp(
      r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  /// Get video thumbnail URL
  String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }
}
