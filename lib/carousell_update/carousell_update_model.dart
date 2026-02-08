import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'carousell_update_widget.dart' show CarousellUpdateWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CarousellUpdateModel extends FlutterFlowModel<CarousellUpdateWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (carousellMovementGet)] action in CarousellUpdate widget.
  ApiCallResponse? getCarousellList;
  // State field(s) for Branch widget.
  String? branchValue;
  FormFieldController<String>? branchValueController;
  // Stores action output result for [Backend Call - API (carousellMovementGet)] action in Branch widget.
  ApiCallResponse? getCarousellList2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future updateCarousellMovement(
    BuildContext context, {
    required String? status,
    required int? id,
    required int? index,
    required String? type,
    String? side,
  }) async {
    ApiCallResponse? updateCarousellMovement;

    updateCarousellMovement =
        await CarousellGroup.carousellMovementPutCall.call(
      id: id,
      status: status,
      side: side,
      name: FFAppState().user.name,
      doneBool: true,
    );

    if ((updateCarousellMovement?.succeeded ?? true)) {
      if (side == 'buyer') {
        FFAppState().removeAtIndexFromCarousellBuyList(index!);
      } else {
        FFAppState().removeAtIndexFromCarousellSellList(index!);
      }
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Error Updating Carousell'),
            content: Text(getJsonField(
              (updateCarousellMovement?.jsonBody ?? ''),
              r'''$.message''',
            ).toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    FFAppState().processing = false;
  }
}
