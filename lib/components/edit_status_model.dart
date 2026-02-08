import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_status_widget.dart' show EditStatusWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditStatusModel extends FlutterFlowModel<EditStatusWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Button widget.
  ApiCallResponse? apiResultioq;
  // Stores action output result for [Backend Call - API (orderLists)] action in Button widget.
  ApiCallResponse? orderLists;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
