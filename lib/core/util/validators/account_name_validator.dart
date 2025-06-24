class AccountNameValidator {
  static bool isValid(String accountName) {
    final trimmed = accountName.trim();
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return trimmed.length >= 3 &&
        trimmed.length <= 20 &&
        regex.hasMatch(trimmed);
  }
}
