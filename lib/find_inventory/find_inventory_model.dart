import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/stock_out_window_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'find_inventory_widget.dart' show FindInventoryWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FindInventoryModel extends FlutterFlowModel<FindInventoryWidget> {
  ///  Local state fields for this page.

  List<InventoryListingStruct> inventoryItems = [];
  void addToInventoryItems(InventoryListingStruct item) =>
      inventoryItems.add(item);
  void removeFromInventoryItems(InventoryListingStruct item) =>
      inventoryItems.remove(item);
  void removeAtIndexFromInventoryItems(int index) =>
      inventoryItems.removeAt(index);
  void insertAtIndexInInventoryItems(int index, InventoryListingStruct item) =>
      inventoryItems.insert(index, item);
  void updateInventoryItemsAtIndex(
          int index, Function(InventoryListingStruct) updateFn) =>
      inventoryItems[index] = updateFn(inventoryItems[index]);

  List<InventoryStruct> inventoryOption = [];
  void addToInventoryOption(InventoryStruct item) => inventoryOption.add(item);
  void removeFromInventoryOption(InventoryStruct item) =>
      inventoryOption.remove(item);
  void removeAtIndexFromInventoryOption(int index) =>
      inventoryOption.removeAt(index);
  void insertAtIndexInInventoryOption(int index, InventoryStruct item) =>
      inventoryOption.insert(index, item);
  void updateInventoryOptionAtIndex(
          int index, Function(InventoryStruct) updateFn) =>
      inventoryOption[index] = updateFn(inventoryOption[index]);

  DateTime? chosenDate;

  int? chosenInventoryId = 0;

  InventoryListingStruct? chosenInventory;
  void updateChosenInventoryStruct(Function(InventoryListingStruct) updateFn) {
    updateFn(chosenInventory ??= InventoryListingStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (inventoryListGet)] action in findInventory widget.
  ApiCallResponse? listInventoryLoad;
  // State field(s) for searchItem widget.
  FocusNode? searchItemFocusNode;
  TextEditingController? searchItemTextController;
  String? Function(BuildContext, String?)? searchItemTextControllerValidator;
  // Stores action output result for [Backend Call - API (inventory)] action in searchItem widget.
  ApiCallResponse? searchInventorySubmit;
  // Stores action output result for [Backend Call - API (inventoryListGet)] action in searchItem widget.
  ApiCallResponse? listInventorySubmit;
  // State field(s) for Branch widget.
  int? branchValue;
  FormFieldController<int>? branchValueController;
  // State field(s) for searchSupplier widget.
  FocusNode? searchSupplierFocusNode;
  TextEditingController? searchSupplierTextController;
  String? Function(BuildContext, String?)?
      searchSupplierTextControllerValidator;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - API (inventory)] action in Button widget.
  ApiCallResponse? searchInventory;
  // Stores action output result for [Backend Call - API (inventoryListGet)] action in Button widget.
  ApiCallResponse? listInventory;
  // Stores action output result for [Backend Call - API (inventoryListGet)] action in Container widget.
  ApiCallResponse? inventoryListing;
  // Model for stockOutWindow component.
  late StockOutWindowModel stockOutWindowModel;

  @override
  void initState(BuildContext context) {
    stockOutWindowModel = createModel(context, () => StockOutWindowModel());
  }

  @override
  void dispose() {
    searchItemFocusNode?.dispose();
    searchItemTextController?.dispose();

    searchSupplierFocusNode?.dispose();
    searchSupplierTextController?.dispose();

    stockOutWindowModel.dispose();
  }
}
