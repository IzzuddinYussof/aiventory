import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/upload_image_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'order_widget.dart' show OrderWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderModel extends FlutterFlowModel<OrderWidget> {
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

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for orderChannel widget.
  String? orderChannelValue;
  FormFieldController<String>? orderChannelValueController;
  // State field(s) for category widget.
  String? categoryValue;
  FormFieldController<String>? categoryValueController;
  // State field(s) for item widget.
  int? itemValue;
  FormFieldController<int>? itemValueController;
  // State field(s) for quantity widget.
  FocusNode? quantityFocusNode;
  TextEditingController? quantityTextController;
  String? Function(BuildContext, String?)? quantityTextControllerValidator;
  String? _quantityTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter quantity to order';
    }

    if (val.length < 1) {
      return 'Requires at least 1 characters.';
    }

    return null;
  }

  // State field(s) for remark widget.
  FocusNode? remarkFocusNode;
  TextEditingController? remarkTextController;
  String? Function(BuildContext, String?)? remarkTextControllerValidator;
  // Model for uploadImage component.
  late UploadImageModel uploadImageModel;
  // Stores action output result for [Backend Call - API (uploadFile)] action in Button widget.
  ApiCallResponse? uploadedFile;
  // Stores action output result for [Backend Call - API (orderStatusUpdate)] action in Button widget.
  ApiCallResponse? newOrder;

  @override
  void initState(BuildContext context) {
    quantityTextControllerValidator = _quantityTextControllerValidator;
    uploadImageModel = createModel(context, () => UploadImageModel());
  }

  @override
  void dispose() {
    quantityFocusNode?.dispose();
    quantityTextController?.dispose();

    remarkFocusNode?.dispose();
    remarkTextController?.dispose();

    uploadImageModel.dispose();
  }
}
