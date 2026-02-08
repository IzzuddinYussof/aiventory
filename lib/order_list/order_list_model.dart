import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/edit_status_widget.dart';
import '/components/text_to_edit_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'order_list_widget.dart' show OrderListWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OrderListModel extends FlutterFlowModel<OrderListWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (orderLists)] action in orderList widget.
  ApiCallResponse? orderLists;
  // State field(s) for noOfDays widget.
  String? noOfDaysValue;
  FormFieldController<String>? noOfDaysValueController;
  // State field(s) for Branch widget.
  String? branchValue;
  FormFieldController<String>? branchValueController;
  // Stores action output result for [Backend Call - API (orderLists)] action in Branch widget.
  ApiCallResponse? orderLists2;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for newRemark.
  late FlutterFlowDynamicModels<TextToEditModel> newRemarkModels;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? newOrder;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? orderCancelled;
  // Models for approveRemark.
  late FlutterFlowDynamicModels<TextToEditModel> approveRemarkModels;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? reverseSubmitted;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? approveOrder;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? orderCancelled2;
  // Models for processedRemark.
  late FlutterFlowDynamicModels<TextToEditModel> processedRemarkModels;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? reverseApproved;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? orderedOrder;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Icon widget.
  ApiCallResponse? orderCancelled3;
  // Model for EditStatus component.
  late EditStatusModel editStatusModel;

  @override
  void initState(BuildContext context) {
    newRemarkModels = FlutterFlowDynamicModels(() => TextToEditModel());
    approveRemarkModels = FlutterFlowDynamicModels(() => TextToEditModel());
    processedRemarkModels = FlutterFlowDynamicModels(() => TextToEditModel());
    editStatusModel = createModel(context, () => EditStatusModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    newRemarkModels.dispose();
    approveRemarkModels.dispose();
    processedRemarkModels.dispose();
    editStatusModel.dispose();
  }
}
