import '/flutter_flow/flutter_flow_util.dart';
import 'notification_settings_page_widget.dart'
    show NotificationSettingsPageWidget;
import 'package:flutter/material.dart';

class NotificationSettingsPageModel
    extends FlutterFlowModel<NotificationSettingsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Switch widget.
  bool pushNotificationsValue = true;
  // State field(s) for Switch widget.
  bool bookingUpdatesValue = true;
  // State field(s) for Switch widget.
  bool chatMessagesValue = true;
  // State field(s) for Switch widget.
  bool promotionalOffersValue = false;
  // State field(s) for Switch widget.
  bool paymentUpdatesValue = true;
  // State field(s) for Switch widget.
  bool doNotDisturbValue = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
