import '/flutter_flow/flutter_flow_util.dart';
import 'provider_profile_page_widget.dart' show ProviderProfilePageWidget;
import 'package:flutter/material.dart';

class ProviderProfilePageModel
    extends FlutterFlowModel<ProviderProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
