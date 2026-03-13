import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'carousell_widget.dart' show CarousellWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CarousellModel extends FlutterFlowModel<CarousellWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (carousellGet)] action in Carousell widget.
  ApiCallResponse? carousellGetBack;
  // State field(s) for branch widget.
  String? branchValue;
  FormFieldController<String>? branchValueController;
  // Stores action output result for [Backend Call - API (carousellGet)] action in Column widget.
  ApiCallResponse? carousellGetRefresh;
  // State field(s) for serachInventory widget.
  FocusNode? serachInventoryFocusNode;
  TextEditingController? serachInventoryTextController;
  String? Function(BuildContext, String?)?
      serachInventoryTextControllerValidator;
  // Stores action output result for [Backend Call - API (carousellGet)] action in serachInventory widget.
  ApiCallResponse? carousellGet;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Backend Call - API (carousellGet)] action in ChoiceChips widget.
  ApiCallResponse? carousellGetChips;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    serachInventoryFocusNode?.dispose();
    serachInventoryTextController?.dispose();
  }
}
