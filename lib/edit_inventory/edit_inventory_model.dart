import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'edit_inventory_widget.dart' show EditInventoryWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditInventoryModel extends FlutterFlowModel<EditInventoryWidget> {
  ///  Local state fields for this page.

  FileStruct? file;
  void updateFileStruct(Function(FileStruct) updateFn) {
    updateFn(file ??= FileStruct());
  }

  FFUploadedFile? uploadedImage;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (getInventory)] action in editInventory widget.
  ApiCallResponse? getInventory;
  // State field(s) for category widget.
  String? categoryValue;
  FormFieldController<String>? categoryValueController;
  // State field(s) for itemName widget.
  FocusNode? itemNameFocusNode;
  TextEditingController? itemNameTextController;
  String? Function(BuildContext, String?)? itemNameTextControllerValidator;
  String? _itemNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for supplier widget.
  FocusNode? supplierFocusNode;
  TextEditingController? supplierTextController;
  String? Function(BuildContext, String?)? supplierTextControllerValidator;
  String? _supplierTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Supplier is required';
    }

    return null;
  }

  // State field(s) for minQuantity widget.
  FocusNode? minQuantityFocusNode;
  TextEditingController? minQuantityTextController;
  String? Function(BuildContext, String?)? minQuantityTextControllerValidator;
  String? _minQuantityTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter quantity to order';
    }

    if (val.length < 1) {
      return 'Requires at least 1 characters.';
    }

    return null;
  }

  // State field(s) for quantMinor widget.
  FocusNode? quantMinorFocusNode;
  TextEditingController? quantMinorTextController;
  String? Function(BuildContext, String?)? quantMinorTextControllerValidator;
  String? _quantMinorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Quantity Minor is required';
    }

    return null;
  }

  // State field(s) for quantMajor widget.
  FocusNode? quantMajorFocusNode;
  TextEditingController? quantMajorTextController;
  String? Function(BuildContext, String?)? quantMajorTextControllerValidator;
  String? _quantMajorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Quantity Major is required';
    }

    return null;
  }

  // State field(s) for ratio widget.
  FocusNode? ratioFocusNode;
  TextEditingController? ratioTextController;
  String? Function(BuildContext, String?)? ratioTextControllerValidator;
  String? _ratioTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ratio is required';
    }

    return null;
  }

  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  // State field(s) for Expiry widget.
  bool? expiryValue;
  // State field(s) for barcode widget.
  FocusNode? barcodeFocusNode;
  TextEditingController? barcodeTextController;
  String? Function(BuildContext, String?)? barcodeTextControllerValidator;
  var barcode = '';
  bool isDataUploading_uploadDataEdit = false;
  FFUploadedFile uploadedLocalFile_uploadDataEdit =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Validate Form] action in Button widget.
  bool? form;
  // Stores action output result for [Backend Call - API (editInventory)] action in Button widget.
  ApiCallResponse? editInventory;
  // Stores action output result for [Backend Call - API (editInventory)] action in Button widget.
  ApiCallResponse? editInventory2;

  @override
  void initState(BuildContext context) {
    itemNameTextControllerValidator = _itemNameTextControllerValidator;
    supplierTextControllerValidator = _supplierTextControllerValidator;
    minQuantityTextControllerValidator = _minQuantityTextControllerValidator;
    quantMinorTextControllerValidator = _quantMinorTextControllerValidator;
    quantMajorTextControllerValidator = _quantMajorTextControllerValidator;
    ratioTextControllerValidator = _ratioTextControllerValidator;
  }

  @override
  void dispose() {
    itemNameFocusNode?.dispose();
    itemNameTextController?.dispose();

    supplierFocusNode?.dispose();
    supplierTextController?.dispose();

    minQuantityFocusNode?.dispose();
    minQuantityTextController?.dispose();

    quantMinorFocusNode?.dispose();
    quantMinorTextController?.dispose();

    quantMajorFocusNode?.dispose();
    quantMajorTextController?.dispose();

    ratioFocusNode?.dispose();
    ratioTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();

    barcodeFocusNode?.dispose();
    barcodeTextController?.dispose();
  }
}
