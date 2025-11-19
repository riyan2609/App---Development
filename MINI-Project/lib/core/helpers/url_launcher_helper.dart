import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  // Launch URL in browser
  static Future<bool> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }

  // Launch email
  static Future<bool> launchEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      String emailUrl = 'mailto:$email';

      List<String> params = [];
      if (subject != null) {
        params.add('subject=${Uri.encodeComponent(subject)}');
      }
      if (body != null) params.add('body=${Uri.encodeComponent(body)}');

      if (params.isNotEmpty) {
        emailUrl += '?${params.join('&')}';
      }

      final Uri uri = Uri.parse(emailUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      print('Error launching email: $e');
      return false;
    }
  }

  // Launch phone call
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final Uri uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      print('Error launching phone: $e');
      return false;
    }
  }

  // Launch SMS
  static Future<bool> launchSMS({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      String smsUrl = 'sms:$phoneNumber';
      if (message != null) {
        smsUrl += '?body=${Uri.encodeComponent(message)}';
      }

      final Uri uri = Uri.parse(smsUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      print('Error launching SMS: $e');
      return false;
    }
  }

  // Launch WhatsApp
  static Future<bool> launchWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      String whatsappUrl = 'https://wa.me/$phoneNumber';
      if (message != null) {
        whatsappUrl += '?text=${Uri.encodeComponent(message)}';
      }

      final Uri uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('Error launching WhatsApp: $e');
      return false;
    }
  }

  // Launch Maps
  static Future<bool> launchMaps({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    try {
      String mapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (label != null) {
        mapsUrl += '&query_place_id=$label';
      }

      final Uri uri = Uri.parse(mapsUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('Error launching maps: $e');
      return false;
    }
  }

  // Launch app store/play store
  static Future<bool> launchAppStore({
    required String appId,
    bool isAndroid = true,
  }) async {
    try {
      String storeUrl = isAndroid
          ? 'https://play.google.com/store/apps/details?id=$appId'
          : 'https://apps.apple.com/app/id$appId';

      final Uri uri = Uri.parse(storeUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      print('Error launching app store: $e');
      return false;
    }
  }

  // Share text
  static Future<bool> shareText(String text) async {
    try {
      final Uri uri = Uri.parse('sms:?body=${Uri.encodeComponent(text)}');
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      print('Error sharing text: $e');
      return false;
    }
  }
}
