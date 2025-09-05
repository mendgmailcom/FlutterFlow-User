import '/flutter_flow/flutter_flow_util.dart';
import 'otp_verification_page_widget.dart' show OtpVerificationPageWidget;
import 'package:flutter/material.dart';

class OtpVerificationPageModel
    extends FlutterFlowModel<OtpVerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for otpDigit1 widget.
  FocusNode? otpDigit1FocusNode;
  TextEditingController? otpDigit1Controller;
  String? Function(BuildContext, String?)? otpDigit1ControllerValidator;
  // State field(s) for otpDigit2 widget.
  FocusNode? otpDigit2FocusNode;
  TextEditingController? otpDigit2Controller;
  String? Function(BuildContext, String?)? otpDigit2ControllerValidator;
  // State field(s) for otpDigit3 widget.
  FocusNode? otpDigit3FocusNode;
  TextEditingController? otpDigit3Controller;
  String? Function(BuildContext, String?)? otpDigit3ControllerValidator;
  // State field(s) for otpDigit4 widget.
  FocusNode? otpDigit4FocusNode;
  TextEditingController? otpDigit4Controller;
  String? Function(BuildContext, String?)? otpDigit4ControllerValidator;
  // State field(s) for otpDigit5 widget.
  FocusNode? otpDigit5FocusNode;
  TextEditingController? otpDigit5Controller;
  String? Function(BuildContext, String?)? otpDigit5ControllerValidator;
  // State field(s) for otpDigit6 widget.
  FocusNode? otpDigit6FocusNode;
  TextEditingController? otpDigit6Controller;
  String? Function(BuildContext, String?)? otpDigit6ControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    otpDigit1FocusNode?.dispose();
    otpDigit1Controller?.dispose();

    otpDigit2FocusNode?.dispose();
    otpDigit2Controller?.dispose();

    otpDigit3FocusNode?.dispose();
    otpDigit3Controller?.dispose();

    otpDigit4FocusNode?.dispose();
    otpDigit4Controller?.dispose();

    otpDigit5FocusNode?.dispose();
    otpDigit5Controller?.dispose();

    otpDigit6FocusNode?.dispose();
    otpDigit6Controller?.dispose();
  }
}
