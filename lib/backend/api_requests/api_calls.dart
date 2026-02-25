import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start inventory Group Code

class InventoryGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static InventoryFindBarcodeCall inventoryFindBarcodeCall =
      InventoryFindBarcodeCall();
  static InventoryCall inventoryCall = InventoryCall();
  static EditInventoryCall editInventoryCall = EditInventoryCall();
  static GetInventoryCall getInventoryCall = GetInventoryCall();
}

class InventoryFindBarcodeCall {
  Future<ApiCallResponse> call({
    String? barcode = '',
  }) async {
    final baseUrl = InventoryGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'inventoryFindBarcode',
      apiUrl: '${baseUrl}/inventory_barcode',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'barcode': barcode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InventoryCall {
  Future<ApiCallResponse> call({
    String? name = '',
    String? category = '',
    String? supplier = '',
  }) async {
    final baseUrl = InventoryGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'inventory',
      apiUrl: '${baseUrl}/inventory',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'name': name,
        'category': category,
        'supplier': supplier,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EditInventoryCall {
  Future<ApiCallResponse> call({
    String? itemName = '',
    String? category = '',
    int? minQuantity,
    String? supplier = '',
    double? priceUnit,
    bool? expiry,
    String? quantityMajor = '',
    String? quantityMinor = '',
    int? ratio,
    String? barcode = '',
    FFUploadedFile? file,
    int? id = 0,
  }) async {
    final baseUrl = InventoryGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'editInventory',
      apiUrl: '${baseUrl}/inventory',
      callType: ApiCallType.PUT,
      headers: {},
      params: {
        'item_name': itemName,
        'category': category,
        'min_quantity': minQuantity,
        'supplier': supplier,
        'price_unit': priceUnit,
        'expiry': expiry,
        'quantity_major': quantityMajor,
        'quantity_minor': quantityMinor,
        'ratio': ratio,
        'barcode': barcode,
        'file': file,
        'id': id,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetInventoryCall {
  Future<ApiCallResponse> call({
    int? inventoryId = 0,
  }) async {
    final baseUrl = InventoryGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'getInventory',
      apiUrl: '${baseUrl}/inventory/${inventoryId}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End inventory Group Code

/// Start auth Group Code

class AuthGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static LoginCall loginCall = LoginCall();
  static AutMeCall autMeCall = AutMeCall();
}

class LoginCall {
  Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'login',
      apiUrl: '${baseUrl}/auth/login',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'email': email,
        'password': password,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? token(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.authToken''',
      ));
}

class AutMeCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'autMe',
      apiUrl: '${baseUrl}/auth/me',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End auth Group Code

/// Start inventoryListing Group Code

class InventoryListingGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static InventoryListGetCall inventoryListGetCall = InventoryListGetCall();
  static InventoryListingExpiringCall inventoryListingExpiringCall =
      InventoryListingExpiringCall();
}

class InventoryListGetCall {
  Future<ApiCallResponse> call({
    int? branchId = 0,
    List<int>? inventoryIdList,
    int? expiryDate = 0,
    int? page = 1,
    int? perPage = 25,
  }) async {
    final inventoryId = _serializeList(inventoryIdList);

    return ApiManager.instance.makeApiCall(
      callName: 'inventoryListGet',
      apiUrl: 'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6/inventory_listing',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'branch_id': branchId,
        'inventory_id': inventoryId,
        'expiry_date': expiryDate,
        'page': page,
        'per_page': perPage,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InventoryListingExpiringCall {
  Future<ApiCallResponse> call({
    int? branchId,
  }) async {
    final baseUrl = InventoryListingGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'inventoryListingExpiring',
      apiUrl: '${baseUrl}/inventory_listing_expiring_count',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'branch_id': branchId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End inventoryListing Group Code

/// Start inventoryMovement Group Code

class InventoryMovementGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static InventoryMovementGetCall inventoryMovementGetCall =
      InventoryMovementGetCall();
  static InventoryMovementPostCall inventoryMovementPostCall =
      InventoryMovementPostCall();
  static ItemHistoryCall itemHistoryCall = ItemHistoryCall();
  static ItemMovementDeleteCall itemMovementDeleteCall =
      ItemMovementDeleteCall();
}

class InventoryMovementGetCall {
  Future<ApiCallResponse> call({
    String? inventoryId = '',
    String? from = '',
    String? to = '',
  }) async {
    final baseUrl = InventoryMovementGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'inventoryMovementGet',
      apiUrl: '${baseUrl}/inventory_movement',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'inventory_id': inventoryId,
        'from': from,
        'to': to,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InventoryMovementPostCall {
  Future<ApiCallResponse> call({
    int? inventoryId = 0,
    String? branch = '',
    String? expiryDate = '',
    double? quantity,
    int? branchIdFrom = 0,
    int? branchIdTo = 0,
    String? unit = '',
    double? unitCost,
    String? txType = '',
    String? note = '',
    String? doc = '',
    String? checksum = '',
    String? updateName = '',
    int? updateTimestamp,
    String? updateBranch = '',
    int? orderListId,
    double? totalCost,
  }) async {
    final baseUrl = InventoryMovementGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "inventory_id": ${inventoryId},
  "updates": {
    "name": "${escapeStringForJson(updateName)}",
    "timestamp": ${updateTimestamp},
    "branch": "${escapeStringForJson(updateBranch)}"
  },
  "branch": "${escapeStringForJson(branch)}",
  "expiry_date": "${escapeStringForJson(expiryDate)}",
  "quantity": ${quantity},
  "branch_id_from": ${branchIdFrom},
  "branch_id_to": ${branchIdTo},
  "unit": "${escapeStringForJson(unit)}",
  "unit_cost": ${unitCost},
  "tx_type": "${escapeStringForJson(txType)}",
  "note": "${escapeStringForJson(note)}",
  "doc": "${escapeStringForJson(doc)}",
  "order_list_id": ${orderListId},
  "total_cost": ${totalCost}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'inventoryMovementPost',
      apiUrl: '${baseUrl}/inventory_movement',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ItemHistoryCall {
  Future<ApiCallResponse> call({
    String? inventoryId = '',
    String? expiryDate = '',
    String? branch = '',
    int? page = 1,
    int? perPage = 25,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'itemHistory',
      apiUrl: 'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6/item_history',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'inventory_id': inventoryId,
        'expiry_date': expiryDate,
        'branch': branch,
        'page': page,
        'per_page': perPage,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ItemMovementDeleteCall {
  Future<ApiCallResponse> call({
    String? inventoryMovementId = '',
    String? inventoryId = '',
    String? branch = '',
    String? expiryDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "inventory_movement_id": "${escapeStringForJson(inventoryMovementId)}",
  "inventory_id": "${escapeStringForJson(inventoryId)}",
  "branch": "${escapeStringForJson(branch)}",
  "expiry_date": "${escapeStringForJson(expiryDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'itemMovementDelete',
      apiUrl:
          'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6/item_movement_delete',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: true,
    );
  }
}

/// End inventoryMovement Group Code

/// Start order Group Code

class OrderGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static OrderGetCall orderGetCall = OrderGetCall();
  static OrderListsCall orderListsCall = OrderListsCall();
  static OrderStatusUpdateCall orderStatusUpdateCall = OrderStatusUpdateCall();
}

class OrderGetCall {
  Future<ApiCallResponse> call({
    int? orderId,
  }) async {
    final baseUrl = OrderGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'orderGet',
      apiUrl: '${baseUrl}/order/${orderId}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class OrderListsCall {
  Future<ApiCallResponse> call({
    String? branch = '',
    List<String>? statusList,
    int? branchId = 0,
  }) async {
    final baseUrl = OrderGroup.getBaseUrl();
    final status = _serializeList(statusList);

    final ffApiRequestBody = '''
{
  "branch": "${escapeStringForJson(branch)}",
  "status": ${status},
  "branch_id": ${branchId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'orderLists',
      apiUrl: '${baseUrl}/order_lists',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class OrderStatusUpdateCall {
  Future<ApiCallResponse> call({
    String? status = '',
    int? id = 0,
    String? name = '',
    String? branch = '',
    double? amount,
    int? inventoryId,
    String? remark = '',
    String? imageUrl = '',
    int? branchId,
    String? channel = '',
  }) async {
    final baseUrl = OrderGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "status": "${escapeStringForJson(status)}",
  "id": ${id},
  "name": "${escapeStringForJson(name)}",
  "branch": "${escapeStringForJson(branch)}",
  "amount": ${amount},
  "inventory_id": ${inventoryId},
  "remark": "${escapeStringForJson(remark)}",
  "image_url": "${escapeStringForJson(imageUrl)}",
  "branch_id": ${branchId},
  "channel": "${escapeStringForJson(channel)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'orderStatusUpdate',
      apiUrl: '${baseUrl}/order_list_status',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End order Group Code

/// Start inventoryCategory Group Code

class InventoryCategoryGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static GetInventoryCategoryCall getInventoryCategoryCall =
      GetInventoryCategoryCall();
}

class GetInventoryCategoryCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = InventoryCategoryGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'getInventoryCategory',
      apiUrl: '${baseUrl}/inventory_category_list',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End inventoryCategory Group Code

/// Start branch Group Code

class BranchGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static BranchListCall branchListCall = BranchListCall();
}

class BranchListCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = BranchGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'branch list',
      apiUrl: '${baseUrl}/branch_list_basic',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End branch Group Code

/// Start dashboard Group Code

class DashboardGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static DashboardHQCall dashboardHQCall = DashboardHQCall();
}

class DashboardHQCall {
  Future<ApiCallResponse> call({
    String? access = '',
    String? branchId = '',
  }) async {
    final baseUrl = DashboardGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'dashboardHQ',
      apiUrl: '${baseUrl}/dashboard_inventory_hq',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'access': access,
        'branch_id': branchId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End dashboard Group Code

/// Start carousell Group Code

class CarousellGroup {
  static String getBaseUrl() =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03';
  static Map<String, String> headers = {};
  static CarousellGetCall carousellGetCall = CarousellGetCall();
  static CarousellPostCall carousellPostCall = CarousellPostCall();
  static CarousellMovementPostCall carousellMovementPostCall =
      CarousellMovementPostCall();
  static CarousellMovementGetCall carousellMovementGetCall =
      CarousellMovementGetCall();
  static CarousellMovementPutCall carousellMovementPutCall =
      CarousellMovementPutCall();
}

class CarousellGetCall {
  Future<ApiCallResponse> call({
    List<int>? inventoryIdsList,
    String? name = '',
    String? category = '',
  }) async {
    final baseUrl = CarousellGroup.getBaseUrl();
    final inventoryIds = _serializeList(inventoryIdsList);

    return ApiManager.instance.makeApiCall(
      callName: 'carousellGet',
      apiUrl: '${baseUrl}/inventory_carousell',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'inventory_ids': inventoryIds,
        'name': name,
        'category': category,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CarousellPostCall {
  Future<ApiCallResponse> call({
    int? inventoryId = 0,
    String? branch = '',
    String? imageUrl = '',
    double? initialQuantity = 0,
    double? availableQuantity = 0,
    double? unitCost = 0,
    double? totalCost = 0,
    String? unit = '',
    double? soldQuantity = 0,
    int? branchId = 0,
    String? remark = '',
    String? expiry = '',
    String? type = '',
  }) async {
    final baseUrl = CarousellGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "inventory_id": ${inventoryId},
  "branch": "${escapeStringForJson(branch)}",
  "branch_id": ${branchId},
  "image_url": "${escapeStringForJson(imageUrl)}",
  "expiry_date": "2025-05-05",
  "initial_quantity": ${initialQuantity},
  "unit_cost": ${unitCost},
  "total_cost": ${totalCost},
  "unit": "${escapeStringForJson(unit)}",
  "available_quantity": ${availableQuantity},
  "sold_quantity": ${soldQuantity},
  "expiry": "${escapeStringForJson(expiry)}",
  "remark": "${escapeStringForJson(remark)}",
  "type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'carousellPost',
      apiUrl: '${baseUrl}/inventory_carousell',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CarousellMovementPostCall {
  Future<ApiCallResponse> call({
    int? branchIdFrom,
    int? branchIdTo,
    int? inventoryCarousellId,
    int? inventoryId,
    int? userId,
    double? quantity,
    double? totalCost,
    String? name = '',
    String? delivery = '',
    String? type = '',
  }) async {
    final baseUrl = CarousellGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'carousellMovementPost',
      apiUrl: '${baseUrl}/inventory_carousell_movement',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'branch_id_from': branchIdFrom,
        'branch_id_to': branchIdTo,
        'inventory_carousell_id': inventoryCarousellId,
        'inventory_id': inventoryId,
        'user_id': userId,
        'quantity': quantity,
        'total_cost': totalCost,
        'name': name,
        'delivery': delivery,
        'type': type,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CarousellMovementGetCall {
  Future<ApiCallResponse> call({
    int? branchId,
    String? status = '',
  }) async {
    final baseUrl = CarousellGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'carousellMovementGet',
      apiUrl: '${baseUrl}/inventory_carousell_movement',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'branch_id': branchId,
        'status': status,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CarousellMovementPutCall {
  Future<ApiCallResponse> call({
    int? id,
    String? status = '',
    String? name = '',
    String? side = '',
    bool? doneBool,
  }) async {
    final baseUrl = CarousellGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'carousellMovementPut',
      apiUrl: '${baseUrl}/inventory_carousell_movement',
      callType: ApiCallType.PUT,
      headers: {},
      params: {
        'id': id,
        'status': status,
        'name': name,
        'side': side,
        'done_bool': doneBool,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End carousell Group Code

/// Start notifyAlert Group Code

class NotifyAlertGroup {
  static String getBaseUrl({
    String? token = '',
  }) =>
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6';
  static Map<String, String> headers = {
    'Key': 'Authorization',
    'Value': 'Bearer [token]',
  };
}

/// End notifyAlert Group Code

class UploadFileCall {
  static Future<ApiCallResponse> call({
    String? mainFolder = '',
    String? subFolder = '',
    FFUploadedFile? file,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'uploadFile',
      apiUrl:
          'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03/uploadFile_inventory',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'main_folder': mainFolder,
        'sub_folder': subFolder,
        'file': file,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UploadImageInventoryCall {
  static Future<ApiCallResponse> call({
    String? parentFolderId = '1Gpq_uo8N6zSDXkpunzVkojqO8qizoTxT',
    String? branchFolderName = '',
    String? staffFolderName = '',
    FFUploadedFile? uploadedFile,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'uploadImageInventory',
      apiUrl:
          'https://asia-southeast1-membership-dentabay-jd1z4o.cloudfunctions.net/upload_image',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'branch_folder_name': branchFolderName,
        'staff_folder_name': staffFolderName,
        'uploadedFile': uploadedFile,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
