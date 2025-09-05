import '/flutter_flow/flutter_flow_util.dart';
import 'booking_page_widget.dart' show BookingPageWidget;
import 'package:flutter/material.dart';

class BookingPageModel extends FlutterFlowModel<BookingPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
