import '/flutter_flow/flutter_flow_util.dart';
import 'payment_settings_page_widget.dart' show PaymentSettingsPageWidget;
import 'package:flutter/material.dart';

class PaymentSettingsPageModel
    extends FlutterFlowModel<PaymentSettingsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Switch widget.
  bool saveTransactionHistoryValue = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
