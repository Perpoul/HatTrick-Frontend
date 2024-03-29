class Validator {
  static String? validateUsername({required String? username}) {
    if (username == null) {
      return null;
    }
    if (username.isEmpty) {
      return "Username cannot be empty";
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) {
      return "Email cannot be empty";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Enter a correct email";
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 6) {
      return "Enter a password with length at least 6";
    }

    return null;
  }
}
