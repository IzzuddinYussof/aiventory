import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Backend Call - API (login)] action in Button widget.
  ApiCallResponse? login;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }

  /// Action blocks.
  Future authMe(BuildContext context) async {
    ApiCallResponse? authMe;
    ApiCallResponse? allInventory;
    ApiCallResponse? branchList;
    ApiCallResponse? inventoryCategory;

    authMe = await AuthGroup.autMeCall.call(
      token: FFAppState().token,
    );

    if ((authMe?.succeeded ?? true)) {
      FFAppState().user = UserStruct.maybeFromMap((authMe?.jsonBody ?? ''))!;
      await Future.wait([
        Future(() async {
          allInventory = await InventoryGroup.inventoryCall.call();

          if ((allInventory?.succeeded ?? true)) {
            FFAppState().allInventory = ((allInventory?.jsonBody ?? '')
                    .toList()
                    .map<InventoryStruct?>(InventoryStruct.maybeFromMap)
                    .toList() as Iterable<InventoryStruct?>)
                .withoutNulls
                .toList()
                .cast<InventoryStruct>();
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Error Retrieving Inventory List'),
                  content: Text(getJsonField(
                    (allInventory?.jsonBody ?? ''),
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
        }),
        Future(() async {
          branchList = await BranchGroup.branchListCall.call();

          if ((branchList?.succeeded ?? true)) {
            FFAppState().branchLists = ((branchList?.jsonBody ?? '')
                    .toList()
                    .map<BranchStruct?>(BranchStruct.maybeFromMap)
                    .toList() as Iterable<BranchStruct?>)
                .withoutNulls
                .toList()
                .cast<BranchStruct>();
            FFAppState().addToBranchLists(BranchStruct(
              id: 0,
              label: 'All Dentabay',
            ));
            FFAppState().branchIdUser = valueOrDefault<int>(
              FFAppState()
                  .branchLists
                  .where((e) => e.label == FFAppState().user.branch)
                  .toList()
                  .firstOrNull
                  ?.id,
              0,
            );
            FFAppState().setActiveBranch(
              id: FFAppState().isHQUser ? 0 : FFAppState().branchIdUser,
              label: FFAppState().isHQUser
                  ? 'All Dentabay'
                  : FFAppState().user.branch,
              notify: false,
            );
            FFAppState().update(() {});

            context.goNamed(DashboardHQWidget.routeName);
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Error Branch List'),
                  content: Text(getJsonField(
                    (branchList?.jsonBody ?? ''),
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
        }),
        Future(() async {
          inventoryCategory =
              await InventoryCategoryGroup.getInventoryCategoryCall.call();

          if ((inventoryCategory?.succeeded ?? true)) {
            FFAppState().inventoryCategoryLists =
                ((inventoryCategory?.jsonBody ?? '')
                        .toList()
                        .map<InventoryCategoryStruct?>(
                            InventoryCategoryStruct.maybeFromMap)
                        .toList() as Iterable<InventoryCategoryStruct?>)
                    .withoutNulls
                    .toList()
                    .cast<InventoryCategoryStruct>();
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Error Inventory Category'),
                  content: Text(getJsonField(
                    (inventoryCategory?.jsonBody ?? ''),
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
        }),
      ]);
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Error authMe'),
            content: Text(getJsonField(
              (authMe?.jsonBody ?? ''),
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
  }
}
