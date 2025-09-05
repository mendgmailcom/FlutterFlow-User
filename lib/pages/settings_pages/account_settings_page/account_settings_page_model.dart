import '/flutter_flow/flutter_flow_util.dart';
import 'account_settings_page_widget.dart' show AccountSettingsPageWidget;
import 'package:flutter/material.dart';

class AccountSettingsPageModel
    extends FlutterFlowModel<AccountSettingsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Switch widget.
  bool darkModeValue = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
