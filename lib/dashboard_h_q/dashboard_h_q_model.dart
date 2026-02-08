import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dashboard_h_q_widget.dart' show DashboardHQWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardHQModel extends FlutterFlowModel<DashboardHQWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (dashboardHQ)] action in dashboardHQ widget.
  ApiCallResponse? dashboardDataBranch;
  // Stores action output result for [Backend Call - API (dashboardHQ)] action in dashboardHQ widget.
  ApiCallResponse? dashboardDataHQ;
  // State field(s) for Branch widget.
  int? branchValue;
  FormFieldController<int>? branchValueController;
  // Stores action output result for [Backend Call - API (dashboardHQ)] action in Branch widget.
  ApiCallResponse? branchDashboard;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
