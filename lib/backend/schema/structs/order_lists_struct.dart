// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderListsStruct extends BaseStruct {
  OrderListsStruct({
    int? id,
    int? createdAt,
    int? inventoryId,
    String? branch,
    int? amount,
    String? status,
    String? imageUrl,
    int? quantityOrdered,
    int? quantityReceived,
    String? note,
    String? poNo,
    SubmitStruct? submit,
    OrderStruct? order,
    ApprovedStruct? approved,
    SubmitSupplierStruct? processed,
    PendingStruct? pending,
    PendingPaymentStruct? pendingPayment,
    CancelStruct? cancel,
    ReceiveStruct? receive,
    InventoryStruct? inventory,
    String? temporary,
  })  : _id = id,
        _createdAt = createdAt,
        _inventoryId = inventoryId,
        _branch = branch,
        _amount = amount,
        _status = status,
        _imageUrl = imageUrl,
        _quantityOrdered = quantityOrdered,
        _quantityReceived = quantityReceived,
        _note = note,
        _poNo = poNo,
        _submit = submit,
        _order = order,
        _approved = approved,
        _processed = processed,
        _pending = pending,
        _pendingPayment = pendingPayment,
        _cancel = cancel,
        _receive = receive,
        _inventory = inventory,
        _temporary = temporary;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
  int? _createdAt;
  int get createdAt => _createdAt ?? 0;
  set createdAt(int? val) => _createdAt = val;

  void incrementCreatedAt(int amount) => createdAt = createdAt + amount;

  bool hasCreatedAt() => _createdAt != null;

  // "inventory_id" field.
  int? _inventoryId;
  int get inventoryId => _inventoryId ?? 0;
  set inventoryId(int? val) => _inventoryId = val;

  void incrementInventoryId(int amount) => inventoryId = inventoryId + amount;

  bool hasInventoryId() => _inventoryId != null;

  // "branch" field.
  String? _branch;
  String get branch => _branch ?? '';
  set branch(String? val) => _branch = val;

  bool hasBranch() => _branch != null;

  // "amount" field.
  int? _amount;
  int get amount => _amount ?? 0;
  set amount(int? val) => _amount = val;

  void incrementAmount(int amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "quantity_ordered" field.
  int? _quantityOrdered;
  int get quantityOrdered => _quantityOrdered ?? 0;
  set quantityOrdered(int? val) => _quantityOrdered = val;

  void incrementQuantityOrdered(int amount) =>
      quantityOrdered = quantityOrdered + amount;

  bool hasQuantityOrdered() => _quantityOrdered != null;

  // "quantity_received" field.
  int? _quantityReceived;
  int get quantityReceived => _quantityReceived ?? 0;
  set quantityReceived(int? val) => _quantityReceived = val;

  void incrementQuantityReceived(int amount) =>
      quantityReceived = quantityReceived + amount;

  bool hasQuantityReceived() => _quantityReceived != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  // "po_no" field.
  String? _poNo;
  String get poNo => _poNo ?? '';
  set poNo(String? val) => _poNo = val;

  bool hasPoNo() => _poNo != null;

  // "submit" field.
  SubmitStruct? _submit;
  SubmitStruct get submit => _submit ?? SubmitStruct();
  set submit(SubmitStruct? val) => _submit = val;

  void updateSubmit(Function(SubmitStruct) updateFn) {
    updateFn(_submit ??= SubmitStruct());
  }

  bool hasSubmit() => _submit != null;

  // "order" field.
  OrderStruct? _order;
  OrderStruct get order => _order ?? OrderStruct();
  set order(OrderStruct? val) => _order = val;

  void updateOrder(Function(OrderStruct) updateFn) {
    updateFn(_order ??= OrderStruct());
  }

  bool hasOrder() => _order != null;

  // "approved" field.
  ApprovedStruct? _approved;
  ApprovedStruct get approved => _approved ?? ApprovedStruct();
  set approved(ApprovedStruct? val) => _approved = val;

  void updateApproved(Function(ApprovedStruct) updateFn) {
    updateFn(_approved ??= ApprovedStruct());
  }

  bool hasApproved() => _approved != null;

  // "processed" field.
  SubmitSupplierStruct? _processed;
  SubmitSupplierStruct get processed => _processed ?? SubmitSupplierStruct();
  set processed(SubmitSupplierStruct? val) => _processed = val;

  void updateProcessed(Function(SubmitSupplierStruct) updateFn) {
    updateFn(_processed ??= SubmitSupplierStruct());
  }

  bool hasProcessed() => _processed != null;

  // "pending" field.
  PendingStruct? _pending;
  PendingStruct get pending => _pending ?? PendingStruct();
  set pending(PendingStruct? val) => _pending = val;

  void updatePending(Function(PendingStruct) updateFn) {
    updateFn(_pending ??= PendingStruct());
  }

  bool hasPending() => _pending != null;

  // "pending_payment" field.
  PendingPaymentStruct? _pendingPayment;
  PendingPaymentStruct get pendingPayment =>
      _pendingPayment ?? PendingPaymentStruct();
  set pendingPayment(PendingPaymentStruct? val) => _pendingPayment = val;

  void updatePendingPayment(Function(PendingPaymentStruct) updateFn) {
    updateFn(_pendingPayment ??= PendingPaymentStruct());
  }

  bool hasPendingPayment() => _pendingPayment != null;

  // "cancel" field.
  CancelStruct? _cancel;
  CancelStruct get cancel => _cancel ?? CancelStruct();
  set cancel(CancelStruct? val) => _cancel = val;

  void updateCancel(Function(CancelStruct) updateFn) {
    updateFn(_cancel ??= CancelStruct());
  }

  bool hasCancel() => _cancel != null;

  // "receive" field.
  ReceiveStruct? _receive;
  ReceiveStruct get receive => _receive ?? ReceiveStruct();
  set receive(ReceiveStruct? val) => _receive = val;

  void updateReceive(Function(ReceiveStruct) updateFn) {
    updateFn(_receive ??= ReceiveStruct());
  }

  bool hasReceive() => _receive != null;

  // "inventory" field.
  InventoryStruct? _inventory;
  InventoryStruct get inventory => _inventory ?? InventoryStruct();
  set inventory(InventoryStruct? val) => _inventory = val;

  void updateInventory(Function(InventoryStruct) updateFn) {
    updateFn(_inventory ??= InventoryStruct());
  }

  bool hasInventory() => _inventory != null;

  // "temporary" field.
  String? _temporary;
  String get temporary => _temporary ?? '';
  set temporary(String? val) => _temporary = val;

  bool hasTemporary() => _temporary != null;

  static OrderListsStruct fromMap(Map<String, dynamic> data) =>
      OrderListsStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        inventoryId: castToType<int>(data['inventory_id']),
        branch: data['branch'] as String?,
        amount: castToType<int>(data['amount']),
        status: data['status'] as String?,
        imageUrl: data['image_url'] as String?,
        quantityOrdered: castToType<int>(data['quantity_ordered']),
        quantityReceived: castToType<int>(data['quantity_received']),
        note: data['note'] as String?,
        poNo: data['po_no'] as String?,
        submit: data['submit'] is SubmitStruct
            ? data['submit']
            : SubmitStruct.maybeFromMap(data['submit']),
        order: data['order'] is OrderStruct
            ? data['order']
            : OrderStruct.maybeFromMap(data['order']),
        approved: data['approved'] is ApprovedStruct
            ? data['approved']
            : ApprovedStruct.maybeFromMap(data['approved']),
        processed: data['processed'] is SubmitSupplierStruct
            ? data['processed']
            : SubmitSupplierStruct.maybeFromMap(data['processed']),
        pending: data['pending'] is PendingStruct
            ? data['pending']
            : PendingStruct.maybeFromMap(data['pending']),
        pendingPayment: data['pending_payment'] is PendingPaymentStruct
            ? data['pending_payment']
            : PendingPaymentStruct.maybeFromMap(data['pending_payment']),
        cancel: data['cancel'] is CancelStruct
            ? data['cancel']
            : CancelStruct.maybeFromMap(data['cancel']),
        receive: data['receive'] is ReceiveStruct
            ? data['receive']
            : ReceiveStruct.maybeFromMap(data['receive']),
        inventory: data['inventory'] is InventoryStruct
            ? data['inventory']
            : InventoryStruct.maybeFromMap(data['inventory']),
        temporary: data['temporary'] as String?,
      );

  static OrderListsStruct? maybeFromMap(dynamic data) => data is Map
      ? OrderListsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'inventory_id': _inventoryId,
        'branch': _branch,
        'amount': _amount,
        'status': _status,
        'image_url': _imageUrl,
        'quantity_ordered': _quantityOrdered,
        'quantity_received': _quantityReceived,
        'note': _note,
        'po_no': _poNo,
        'submit': _submit?.toMap(),
        'order': _order?.toMap(),
        'approved': _approved?.toMap(),
        'processed': _processed?.toMap(),
        'pending': _pending?.toMap(),
        'pending_payment': _pendingPayment?.toMap(),
        'cancel': _cancel?.toMap(),
        'receive': _receive?.toMap(),
        'inventory': _inventory?.toMap(),
        'temporary': _temporary,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.int,
        ),
        'inventory_id': serializeParam(
          _inventoryId,
          ParamType.int,
        ),
        'branch': serializeParam(
          _branch,
          ParamType.String,
        ),
        'amount': serializeParam(
          _amount,
          ParamType.int,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'quantity_ordered': serializeParam(
          _quantityOrdered,
          ParamType.int,
        ),
        'quantity_received': serializeParam(
          _quantityReceived,
          ParamType.int,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
        'po_no': serializeParam(
          _poNo,
          ParamType.String,
        ),
        'submit': serializeParam(
          _submit,
          ParamType.DataStruct,
        ),
        'order': serializeParam(
          _order,
          ParamType.DataStruct,
        ),
        'approved': serializeParam(
          _approved,
          ParamType.DataStruct,
        ),
        'processed': serializeParam(
          _processed,
          ParamType.DataStruct,
        ),
        'pending': serializeParam(
          _pending,
          ParamType.DataStruct,
        ),
        'pending_payment': serializeParam(
          _pendingPayment,
          ParamType.DataStruct,
        ),
        'cancel': serializeParam(
          _cancel,
          ParamType.DataStruct,
        ),
        'receive': serializeParam(
          _receive,
          ParamType.DataStruct,
        ),
        'inventory': serializeParam(
          _inventory,
          ParamType.DataStruct,
        ),
        'temporary': serializeParam(
          _temporary,
          ParamType.String,
        ),
      }.withoutNulls;

  static OrderListsStruct fromSerializableMap(Map<String, dynamic> data) =>
      OrderListsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.int,
          false,
        ),
        inventoryId: deserializeParam(
          data['inventory_id'],
          ParamType.int,
          false,
        ),
        branch: deserializeParam(
          data['branch'],
          ParamType.String,
          false,
        ),
        amount: deserializeParam(
          data['amount'],
          ParamType.int,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        quantityOrdered: deserializeParam(
          data['quantity_ordered'],
          ParamType.int,
          false,
        ),
        quantityReceived: deserializeParam(
          data['quantity_received'],
          ParamType.int,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
        poNo: deserializeParam(
          data['po_no'],
          ParamType.String,
          false,
        ),
        submit: deserializeStructParam(
          data['submit'],
          ParamType.DataStruct,
          false,
          structBuilder: SubmitStruct.fromSerializableMap,
        ),
        order: deserializeStructParam(
          data['order'],
          ParamType.DataStruct,
          false,
          structBuilder: OrderStruct.fromSerializableMap,
        ),
        approved: deserializeStructParam(
          data['approved'],
          ParamType.DataStruct,
          false,
          structBuilder: ApprovedStruct.fromSerializableMap,
        ),
        processed: deserializeStructParam(
          data['processed'],
          ParamType.DataStruct,
          false,
          structBuilder: SubmitSupplierStruct.fromSerializableMap,
        ),
        pending: deserializeStructParam(
          data['pending'],
          ParamType.DataStruct,
          false,
          structBuilder: PendingStruct.fromSerializableMap,
        ),
        pendingPayment: deserializeStructParam(
          data['pending_payment'],
          ParamType.DataStruct,
          false,
          structBuilder: PendingPaymentStruct.fromSerializableMap,
        ),
        cancel: deserializeStructParam(
          data['cancel'],
          ParamType.DataStruct,
          false,
          structBuilder: CancelStruct.fromSerializableMap,
        ),
        receive: deserializeStructParam(
          data['receive'],
          ParamType.DataStruct,
          false,
          structBuilder: ReceiveStruct.fromSerializableMap,
        ),
        inventory: deserializeStructParam(
          data['inventory'],
          ParamType.DataStruct,
          false,
          structBuilder: InventoryStruct.fromSerializableMap,
        ),
        temporary: deserializeParam(
          data['temporary'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OrderListsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OrderListsStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        inventoryId == other.inventoryId &&
        branch == other.branch &&
        amount == other.amount &&
        status == other.status &&
        imageUrl == other.imageUrl &&
        quantityOrdered == other.quantityOrdered &&
        quantityReceived == other.quantityReceived &&
        note == other.note &&
        poNo == other.poNo &&
        submit == other.submit &&
        order == other.order &&
        approved == other.approved &&
        processed == other.processed &&
        pending == other.pending &&
        pendingPayment == other.pendingPayment &&
        cancel == other.cancel &&
        receive == other.receive &&
        inventory == other.inventory &&
        temporary == other.temporary;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        inventoryId,
        branch,
        amount,
        status,
        imageUrl,
        quantityOrdered,
        quantityReceived,
        note,
        poNo,
        submit,
        order,
        approved,
        processed,
        pending,
        pendingPayment,
        cancel,
        receive,
        inventory,
        temporary
      ]);
}

OrderListsStruct createOrderListsStruct({
  int? id,
  int? createdAt,
  int? inventoryId,
  String? branch,
  int? amount,
  String? status,
  String? imageUrl,
  int? quantityOrdered,
  int? quantityReceived,
  String? note,
  String? poNo,
  SubmitStruct? submit,
  OrderStruct? order,
  ApprovedStruct? approved,
  SubmitSupplierStruct? processed,
  PendingStruct? pending,
  PendingPaymentStruct? pendingPayment,
  CancelStruct? cancel,
  ReceiveStruct? receive,
  InventoryStruct? inventory,
  String? temporary,
}) =>
    OrderListsStruct(
      id: id,
      createdAt: createdAt,
      inventoryId: inventoryId,
      branch: branch,
      amount: amount,
      status: status,
      imageUrl: imageUrl,
      quantityOrdered: quantityOrdered,
      quantityReceived: quantityReceived,
      note: note,
      poNo: poNo,
      submit: submit ?? SubmitStruct(),
      order: order ?? OrderStruct(),
      approved: approved ?? ApprovedStruct(),
      processed: processed ?? SubmitSupplierStruct(),
      pending: pending ?? PendingStruct(),
      pendingPayment: pendingPayment ?? PendingPaymentStruct(),
      cancel: cancel ?? CancelStruct(),
      receive: receive ?? ReceiveStruct(),
      inventory: inventory ?? InventoryStruct(),
      temporary: temporary,
    );
