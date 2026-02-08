import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'cart_widget.dart' show CartWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartModel extends FlutterFlowModel<CartWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for delivery widget.
  String? deliveryValue;
  FormFieldController<String>? deliveryValueController;
  // Stores action output result for [Backend Call - API (carousellMovementPost)] action in Button widget.
  ApiCallResponse? carousellMovementPost;
  // Stores action output result for [Backend Call - API (carousellGet)] action in Button widget.
  ApiCallResponse? carousellUpdate;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
