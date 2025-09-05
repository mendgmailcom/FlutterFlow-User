import '/flutter_flow/flutter_flow_util.dart';
import 'service_categories_page_widget.dart' show ServiceCategoriesPageWidget;
import 'package:flutter/material.dart';

class ServiceCategoriesPageModel
    extends FlutterFlowModel<ServiceCategoriesPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode;
  TextEditingController? searchBarController;
  String? Function(BuildContext, String?)? searchBarControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    searchBarFocusNode?.dispose();
    searchBarController?.dispose();
  }
}
