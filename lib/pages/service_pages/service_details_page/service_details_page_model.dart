import '/flutter_flow/flutter_flow_util.dart';
import 'service_details_page_widget.dart' show ServiceDetailsPageWidget;
import 'package:flutter/material.dart';

class ServiceDetailsPageModel
    extends FlutterFlowModel<ServiceDetailsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
