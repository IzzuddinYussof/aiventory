import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/upload_image_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'upload_carousell_widget.dart' show UploadCarousellWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadCarousellModel extends FlutterFlowModel<UploadCarousellWidget> {
  ///  Local state fields for this page.

  List<InventoryStruct> itemList = [];
  void addToItemList(InventoryStruct item) => itemList.add(item);
  void removeFromItemList(InventoryStruct item) => itemList.remove(item);
  void removeAtIndexFromItemList(int index) => itemList.removeAt(index);
  void insertAtIndexInItemList(int index, InventoryStruct item) =>
      itemList.insert(index, item);
  void updateItemListAtIndex(int index, Function(InventoryStruct) updateFn) =>
      itemList[index] = updateFn(itemList[index]);

  FileStruct? file;
  void updateFileStruct(Function(FileStruct) updateFn) {
    updateFn(file ??= FileStruct());
  }

  FFUploadedFile? uploadedImage;

  InventoryStruct? inventoryChosen;
  void updateInventoryChosenStruct(Function(InventoryStruct) updateFn) {
    updateFn(inventoryChosen ??= InventoryStruct());
  }

  String? expiryDate;

  List<String> unitList = [];
  void addToUnitList(String item) => unitList.add(item);
  void removeFromUnitList(String item) => unitList.remove(item);
  void removeAtIndexFromUnitList(int index) => unitList.removeAt(index);
  void insertAtIndexInUnitList(int index, String item) =>
      unitList.insert(index, item);
  void updateUnitListAtIndex(int index, Function(String) updateFn) =>
      unitList[index] = updateFn(unitList[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for category widget.
  String? categoryValue;
  FormFieldController<String>? categoryValueController;
  // State field(s) for item widget.
  int? itemValue;
  FormFieldController<int>? itemValueController;
  var barcode = '';
  // State field(s) for type widget.
  String? typeValue;
  FormFieldController<String>? typeValueController;
  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  String? _priceTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Price per unit is required';
    }

    return null;
  }

  // State field(s) for unit widget.
  String? unitValue;
  FormFieldController<String>? unitValueController;
  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;
  String? _quantityTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Quantity * is required';
    }

    return null;
  }

  DateTime? datePicked;
  // State field(s) for remark widget.
  FocusNode? remarkFocusNode;
  TextEditingController? remarkTextController;
  String? Function(BuildContext, String?)? remarkTextControllerValidator;
  // Model for uploadImage component.
  late UploadImageModel uploadImageModel;
  // Stores action output result for [Validate Form] action in UploadButton widget.
  bool? formFilled;
  // Stores action output result for [Backend Call - API (uploadFile)] action in UploadButton widget.
  ApiCallResponse? uploadedFile;
  // Stores action output result for [Backend Call - API (carousellPost)] action in UploadButton widget.
  ApiCallResponse? uploadCarousell;
  // Stores action output result for [Backend Call - API (carousellGet)] action in UploadButton widget.
  ApiCallResponse? carousellRefreshUpload;

  @override
  void initState(BuildContext context) {
    priceTextControllerValidator = _priceTextControllerValidator;
    quantityTextControllerValidator = _quantityTextControllerValidator;
    uploadImageModel = createModel(context, () => UploadImageModel());
  }

  @override
  void dispose() {
    priceFocusNode?.dispose();
    priceTextController?.dispose();

    quantityFocusNode?.dispose();
    quantityTextController?.dispose();

    remarkFocusNode?.dispose();
    remarkTextController?.dispose();

    uploadImageModel.dispose();
  }
}
