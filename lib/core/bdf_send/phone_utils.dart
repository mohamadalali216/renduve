/// Utility for phone number normalization.
/// Currently Syrian-focused (963 prefix), extensible.
class PhoneUtils {
  /// Normalize phone: remove spaces/-/+/( ), strip leading 0, add 963 for Syrian 9-digit.
  static String normalizePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '';
    
    var clean = phone.trim().replaceAll(RegExp(r'[\\s\\-\\+()]'), '');
    if (clean.startsWith('0')) {
      clean = clean.substring(1);
    }
    // Syrian local: 9 digits starting 5-9 → add 963
    if (RegExp(r'^[5-9]\d{8}$').hasMatch(clean)) {
      return '963$clean';
    }
    return clean; // fallback for international
  }
}
