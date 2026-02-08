import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'stock_in_widget.dart' show StockInWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StockInModel extends FlutterFlowModel<StockInWidget> {
  ///  Local state fields for this page.

  InventoryStruct? inventoryChosen;
  void updateInventoryChosenStruct(Function(InventoryStruct) updateFn) {
    updateFn(inventoryChosen ??= InventoryStruct());
  }

  List<InventoryStruct> inventoryOptionLists = [];
  void addToInventoryOptionLists(InventoryStruct item) =>
      inventoryOptionLists.add(item);
  void removeFromInventoryOptionLists(InventoryStruct item) =>
      inventoryOptionLists.remove(item);
  void removeAtIndexFromInventoryOptionLists(int index) =>
      inventoryOptionLists.removeAt(index);
  void insertAtIndexInInventoryOptionLists(int index, InventoryStruct item) =>
      inventoryOptionLists.insert(index, item);
  void updateInventoryOptionListsAtIndex(
          int index, Function(InventoryStruct) updateFn) =>
      inventoryOptionLists[index] = updateFn(inventoryOptionLists[index]);

  FFUploadedFile? uploadedImage;

  String expiryDate = 'Expiry Date';

  String? fileURL;

  List<String> unitOptions = [];
  void addToUnitOptions(String item) => unitOptions.add(item);
  void removeFromUnitOptions(String item) => unitOptions.remove(item);
  void removeAtIndexFromUnitOptions(int index) => unitOptions.removeAt(index);
  void insertAtIndexInUnitOptions(int index, String item) =>
      unitOptions.insert(index, item);
  void updateUnitOptionsAtIndex(int index, Function(String) updateFn) =>
      unitOptions[index] = updateFn(unitOptions[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;
  // Stores action output result for [Backend Call - API (inventory)] action in search widget.
  ApiCallResponse? findInventoryEnter;
  // Stores action output result for [Backend Call - API (inventory)] action in Card widget.
  ApiCallResponse? findInventory;
  var barcode = '';
  // Stores action output result for [Backend Call - API (inventoryFindBarcode)] action in Card widget.
  ApiCallResponse? findBarcode;
  // State field(s) for Type widget.
  FocusNode? typeFocusNode;
  TextEditingController? typeTextController;
  String? Function(BuildContext, String?)? typeTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;
  // State field(s) for DropDownUnit widget.
  String? dropDownUnitValue;
  FormFieldController<String>? dropDownUnitValueController;
  // State field(s) for unitCost widget.
  FocusNode? unitCostFocusNode;
  TextEditingController? unitCostTextController;
  String? Function(BuildContext, String?)? unitCostTextControllerValidator;
  // State field(s) for totalCost widget.
  FocusNode? totalCostFocusNode;
  TextEditingController? totalCostTextController;
  String? Function(BuildContext, String?)? totalCostTextControllerValidator;
  // State field(s) for remark widget.
  FocusNode? remarkFocusNode;
  TextEditingController? remarkTextController;
  String? Function(BuildContext, String?)? remarkTextControllerValidator;
  bool isDataUploading_uploadDataLocal = false;
  FFUploadedFile uploadedLocalFile_uploadDataLocal =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Backend Call - API (uploadFile)] action in Button widget.
  ApiCallResponse? uploadedFile;
  // Stores action output result for [Backend Call - API (inventoryMovementPost)] action in Button widget.
  ApiCallResponse? saveInventoryMovement;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Button widget.
  ApiCallResponse? updateReceived;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();

    typeFocusNode?.dispose();
    typeTextController?.dispose();

    quantityFocusNode?.dispose();
    quantityTextController?.dispose();

    unitCostFocusNode?.dispose();
    unitCostTextController?.dispose();

    totalCostFocusNode?.dispose();
    totalCostTextController?.dispose();

    remarkFocusNode?.dispose();
    remarkTextController?.dispose();
  }
}
