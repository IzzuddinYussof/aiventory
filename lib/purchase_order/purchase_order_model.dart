import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'purchase_order_widget.dart' show PurchaseOrderWidget;
import 'package:flutter/material.dart';

class PurchaseOrderModel extends FlutterFlowModel<PurchaseOrderWidget> {
  ApiCallResponse? purchaseOrderResponse;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
