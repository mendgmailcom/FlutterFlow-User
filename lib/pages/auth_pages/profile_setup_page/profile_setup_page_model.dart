import '/flutter_flow/flutter_flow_util.dart';
import 'profile_setup_page_widget.dart' show ProfileSetupPageWidget;
import 'package:flutter/material.dart';

class ProfileSetupPageModel extends FlutterFlowModel<ProfileSetupPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for fullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(BuildContext, String?)? fullNameControllerValidator;
  String? _fullNameControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Full Name is required.';
    }

    if (val.length < 3) {
      return 'Full Name must be at least 3 characters.';
    }
    return null;
  }

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email Address is required.';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    fullNameControllerValidator = _fullNameControllerValidator;
    emailAddressControllerValidator = _emailAddressControllerValidator;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();
  }
}
