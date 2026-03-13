import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _token = prefs.getString('ff_token') ?? _token;
    });
    _safeInit(() {
      _allInventory = prefs
              .getStringList('ff_allInventory')
              ?.map((x) {
                try {
                  return InventoryStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _allInventory;
    });
    _safeInit(() {
      _branch = prefs.getString('ff_branch') ?? _branch;
    });
    _safeInit(() {
      _branchId = prefs.getInt('ff_branchId') ?? _branchId;
    });
    _safeInit(() {
      _inventoryCategoryLists = prefs
              .getStringList('ff_inventoryCategoryLists')
              ?.map((x) {
                try {
                  return InventoryCategoryStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _inventoryCategoryLists;
    });
    _safeInit(() {
      _branchLists = prefs
              .getStringList('ff_branchLists')
              ?.map((x) {
                try {
                  return BranchStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _branchLists;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _Toggle = false;
  bool get Toggle => _Toggle;
  set Toggle(bool value) {
    _Toggle = value;
  }

  InventoryStruct _inventoryCurrent = InventoryStruct();
  InventoryStruct get inventoryCurrent => _inventoryCurrent;
  set inventoryCurrent(InventoryStruct value) {
    _inventoryCurrent = value;
  }

  void updateInventoryCurrentStruct(Function(InventoryStruct) updateFn) {
    updateFn(_inventoryCurrent);
  }

  List<InventoryStruct> _inventoryOptions = [];
  List<InventoryStruct> get inventoryOptions => _inventoryOptions;
  set inventoryOptions(List<InventoryStruct> value) {
    _inventoryOptions = value;
  }

  void addToInventoryOptions(InventoryStruct value) {
    inventoryOptions.add(value);
  }

  void removeFromInventoryOptions(InventoryStruct value) {
    inventoryOptions.remove(value);
  }

  void removeAtIndexFromInventoryOptions(int index) {
    inventoryOptions.removeAt(index);
  }

  void updateInventoryOptionsAtIndex(
    int index,
    InventoryStruct Function(InventoryStruct) updateFn,
  ) {
    inventoryOptions[index] = updateFn(_inventoryOptions[index]);
  }

  void insertAtIndexInInventoryOptions(int index, InventoryStruct value) {
    inventoryOptions.insert(index, value);
  }

  String _token = '';
  String get token => _token;
  set token(String value) {
    _token = value;
    prefs.setString('ff_token', value);
  }

  UserStruct _user = UserStruct();
  UserStruct get user => _user;
  set user(UserStruct value) {
    _user = value;
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
  }

  List<InventoryStruct> _allInventory = [];
  List<InventoryStruct> get allInventory => _allInventory;
  set allInventory(List<InventoryStruct> value) {
    _allInventory = value;
    prefs.setStringList(
        'ff_allInventory', value.map((x) => x.serialize()).toList());
  }

  void addToAllInventory(InventoryStruct value) {
    allInventory.add(value);
    prefs.setStringList(
        'ff_allInventory', _allInventory.map((x) => x.serialize()).toList());
  }

  void removeFromAllInventory(InventoryStruct value) {
    allInventory.remove(value);
    prefs.setStringList(
        'ff_allInventory', _allInventory.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAllInventory(int index) {
    allInventory.removeAt(index);
    prefs.setStringList(
        'ff_allInventory', _allInventory.map((x) => x.serialize()).toList());
  }

  void updateAllInventoryAtIndex(
    int index,
    InventoryStruct Function(InventoryStruct) updateFn,
  ) {
    allInventory[index] = updateFn(_allInventory[index]);
    prefs.setStringList(
        'ff_allInventory', _allInventory.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAllInventory(int index, InventoryStruct value) {
    allInventory.insert(index, value);
    prefs.setStringList(
        'ff_allInventory', _allInventory.map((x) => x.serialize()).toList());
  }

  String _branch = '';
  String get branch => _branch;
  set branch(String value) {
    _branch = value;
    prefs.setString('ff_branch', value);
  }

  int _branchId = 0;
  int get branchId => _branchId;
  set branchId(int value) {
    _branchId = value;
    prefs.setInt('ff_branchId', value);
  }

  bool get isHQUser => user.branch == 'AI Venture';
  bool get isAllBranchesSelection =>
      isHQUser && (branchId == 0 || branch == 'All Dentabay');
  String get activeBranch => branch;
  int get activeBranchId => branchId;
  String? get activeBranchFilter => isAllBranchesSelection ? null : branch;
  int? get activeBranchFilterId => isAllBranchesSelection ? null : branchId;
  String? get activeBranchFilterIdString => activeBranchFilterId?.toString();

  void setActiveBranch({
    required int id,
    required String label,
    bool notify = true,
  }) {
    branchId = id;
    branch = label;
    if (notify) {
      notifyListeners();
    }
  }

  void setActiveBranchById(int id, {bool notify = true}) {
    final selectedBranch =
        branchLists.where((e) => e.id == id).toList().firstOrNull;
    if (selectedBranch == null) {
      return;
    }
    setActiveBranch(
        id: selectedBranch.id, label: selectedBranch.label, notify: notify);
  }

  void setActiveBranchByLabel(String label, {bool notify = true}) {
    final selectedBranch =
        branchLists.where((e) => e.label == label).toList().firstOrNull;
    if (selectedBranch == null) {
      return;
    }
    setActiveBranch(
        id: selectedBranch.id, label: selectedBranch.label, notify: notify);
  }

  List<InventoryCategoryStruct> _inventoryCategoryLists = [];
  List<InventoryCategoryStruct> get inventoryCategoryLists =>
      _inventoryCategoryLists;
  set inventoryCategoryLists(List<InventoryCategoryStruct> value) {
    _inventoryCategoryLists = value;
    prefs.setStringList(
        'ff_inventoryCategoryLists', value.map((x) => x.serialize()).toList());
  }

  void addToInventoryCategoryLists(InventoryCategoryStruct value) {
    inventoryCategoryLists.add(value);
    prefs.setStringList('ff_inventoryCategoryLists',
        _inventoryCategoryLists.map((x) => x.serialize()).toList());
  }

  void removeFromInventoryCategoryLists(InventoryCategoryStruct value) {
    inventoryCategoryLists.remove(value);
    prefs.setStringList('ff_inventoryCategoryLists',
        _inventoryCategoryLists.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromInventoryCategoryLists(int index) {
    inventoryCategoryLists.removeAt(index);
    prefs.setStringList('ff_inventoryCategoryLists',
        _inventoryCategoryLists.map((x) => x.serialize()).toList());
  }

  void updateInventoryCategoryListsAtIndex(
    int index,
    InventoryCategoryStruct Function(InventoryCategoryStruct) updateFn,
  ) {
    inventoryCategoryLists[index] = updateFn(_inventoryCategoryLists[index]);
    prefs.setStringList('ff_inventoryCategoryLists',
        _inventoryCategoryLists.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInInventoryCategoryLists(
      int index, InventoryCategoryStruct value) {
    inventoryCategoryLists.insert(index, value);
    prefs.setStringList('ff_inventoryCategoryLists',
        _inventoryCategoryLists.map((x) => x.serialize()).toList());
  }

  List<OrderListsStruct> _orderLists = [];
  List<OrderListsStruct> get orderLists => _orderLists;
  set orderLists(List<OrderListsStruct> value) {
    _orderLists = value;
  }

  void addToOrderLists(OrderListsStruct value) {
    orderLists.add(value);
  }

  void removeFromOrderLists(OrderListsStruct value) {
    orderLists.remove(value);
  }

  void removeAtIndexFromOrderLists(int index) {
    orderLists.removeAt(index);
  }

  void updateOrderListsAtIndex(
    int index,
    OrderListsStruct Function(OrderListsStruct) updateFn,
  ) {
    orderLists[index] = updateFn(_orderLists[index]);
  }

  void insertAtIndexInOrderLists(int index, OrderListsStruct value) {
    orderLists.insert(index, value);
  }

  List<BranchStruct> _branchLists = [];
  List<BranchStruct> get branchLists => _branchLists;
  set branchLists(List<BranchStruct> value) {
    _branchLists = value;
    prefs.setStringList(
        'ff_branchLists', value.map((x) => x.serialize()).toList());
  }

  void addToBranchLists(BranchStruct value) {
    branchLists.add(value);
    prefs.setStringList(
        'ff_branchLists', _branchLists.map((x) => x.serialize()).toList());
  }

  void removeFromBranchLists(BranchStruct value) {
    branchLists.remove(value);
    prefs.setStringList(
        'ff_branchLists', _branchLists.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromBranchLists(int index) {
    branchLists.removeAt(index);
    prefs.setStringList(
        'ff_branchLists', _branchLists.map((x) => x.serialize()).toList());
  }

  void updateBranchListsAtIndex(
    int index,
    BranchStruct Function(BranchStruct) updateFn,
  ) {
    branchLists[index] = updateFn(_branchLists[index]);
    prefs.setStringList(
        'ff_branchLists', _branchLists.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInBranchLists(int index, BranchStruct value) {
    branchLists.insert(index, value);
    prefs.setStringList(
        'ff_branchLists', _branchLists.map((x) => x.serialize()).toList());
  }

  UploadFileStruct _uploadedFile = UploadFileStruct();
  UploadFileStruct get uploadedFile => _uploadedFile;
  set uploadedFile(UploadFileStruct value) {
    _uploadedFile = value;
  }

  void updateUploadedFileStruct(Function(UploadFileStruct) updateFn) {
    updateFn(_uploadedFile);
  }

  FileStruct _file = FileStruct();
  FileStruct get file => _file;
  set file(FileStruct value) {
    _file = value;
  }

  void updateFileStruct(Function(FileStruct) updateFn) {
    updateFn(_file);
  }

  DashboardHQDataStruct _DashboardHQ = DashboardHQDataStruct();
  DashboardHQDataStruct get DashboardHQ => _DashboardHQ;
  set DashboardHQ(DashboardHQDataStruct value) {
    _DashboardHQ = value;
  }

  void updateDashboardHQStruct(Function(DashboardHQDataStruct) updateFn) {
    updateFn(_DashboardHQ);
  }

  List<OrderFlowStruct> _orderFlow = [];
  List<OrderFlowStruct> get orderFlow => _orderFlow;
  set orderFlow(List<OrderFlowStruct> value) {
    _orderFlow = value;
  }

  void addToOrderFlow(OrderFlowStruct value) {
    orderFlow.add(value);
  }

  void removeFromOrderFlow(OrderFlowStruct value) {
    orderFlow.remove(value);
  }

  void removeAtIndexFromOrderFlow(int index) {
    orderFlow.removeAt(index);
  }

  void updateOrderFlowAtIndex(
    int index,
    OrderFlowStruct Function(OrderFlowStruct) updateFn,
  ) {
    orderFlow[index] = updateFn(_orderFlow[index]);
  }

  void insertAtIndexInOrderFlow(int index, OrderFlowStruct value) {
    orderFlow.insert(index, value);
  }

  int _expiringCount = 0;
  int get expiringCount => _expiringCount;
  set expiringCount(int value) {
    _expiringCount = value;
  }

  List<CarousellStruct> _carousellList = [];
  List<CarousellStruct> get carousellList => _carousellList;
  set carousellList(List<CarousellStruct> value) {
    _carousellList = value;
  }

  void addToCarousellList(CarousellStruct value) {
    carousellList.add(value);
  }

  void removeFromCarousellList(CarousellStruct value) {
    carousellList.remove(value);
  }

  void removeAtIndexFromCarousellList(int index) {
    carousellList.removeAt(index);
  }

  void updateCarousellListAtIndex(
    int index,
    CarousellStruct Function(CarousellStruct) updateFn,
  ) {
    carousellList[index] = updateFn(_carousellList[index]);
  }

  void insertAtIndexInCarousellList(int index, CarousellStruct value) {
    carousellList.insert(index, value);
  }

  List<CarousellMovementStruct> _carousellStatusUpdate = [];
  List<CarousellMovementStruct> get carousellStatusUpdate =>
      _carousellStatusUpdate;
  set carousellStatusUpdate(List<CarousellMovementStruct> value) {
    _carousellStatusUpdate = value;
  }

  void addToCarousellStatusUpdate(CarousellMovementStruct value) {
    carousellStatusUpdate.add(value);
  }

  void removeFromCarousellStatusUpdate(CarousellMovementStruct value) {
    carousellStatusUpdate.remove(value);
  }

  void removeAtIndexFromCarousellStatusUpdate(int index) {
    carousellStatusUpdate.removeAt(index);
  }

  void updateCarousellStatusUpdateAtIndex(
    int index,
    CarousellMovementStruct Function(CarousellMovementStruct) updateFn,
  ) {
    carousellStatusUpdate[index] = updateFn(_carousellStatusUpdate[index]);
  }

  void insertAtIndexInCarousellStatusUpdate(
      int index, CarousellMovementStruct value) {
    carousellStatusUpdate.insert(index, value);
  }

  List<CarousellMovementStruct> _carousellBuyList = [];
  List<CarousellMovementStruct> get carousellBuyList => _carousellBuyList;
  set carousellBuyList(List<CarousellMovementStruct> value) {
    _carousellBuyList = value;
  }

  void addToCarousellBuyList(CarousellMovementStruct value) {
    carousellBuyList.add(value);
  }

  void removeFromCarousellBuyList(CarousellMovementStruct value) {
    carousellBuyList.remove(value);
  }

  void removeAtIndexFromCarousellBuyList(int index) {
    carousellBuyList.removeAt(index);
  }

  void updateCarousellBuyListAtIndex(
    int index,
    CarousellMovementStruct Function(CarousellMovementStruct) updateFn,
  ) {
    carousellBuyList[index] = updateFn(_carousellBuyList[index]);
  }

  void insertAtIndexInCarousellBuyList(
      int index, CarousellMovementStruct value) {
    carousellBuyList.insert(index, value);
  }

  List<CarousellMovementStruct> _carousellSellList = [];
  List<CarousellMovementStruct> get carousellSellList => _carousellSellList;
  set carousellSellList(List<CarousellMovementStruct> value) {
    _carousellSellList = value;
  }

  void addToCarousellSellList(CarousellMovementStruct value) {
    carousellSellList.add(value);
  }

  void removeFromCarousellSellList(CarousellMovementStruct value) {
    carousellSellList.remove(value);
  }

  void removeAtIndexFromCarousellSellList(int index) {
    carousellSellList.removeAt(index);
  }

  void updateCarousellSellListAtIndex(
    int index,
    CarousellMovementStruct Function(CarousellMovementStruct) updateFn,
  ) {
    carousellSellList[index] = updateFn(_carousellSellList[index]);
  }

  void insertAtIndexInCarousellSellList(
      int index, CarousellMovementStruct value) {
    carousellSellList.insert(index, value);
  }

  bool _processing = false;
  bool get processing => _processing;
  set processing(bool value) {
    _processing = value;
  }

  int _branchIdUser = 0;
  int get branchIdUser => _branchIdUser;
  set branchIdUser(int value) {
    _branchIdUser = value;
  }

  InventoryListingStruct _chosenInventory = InventoryListingStruct();
  InventoryListingStruct get chosenInventory => _chosenInventory;
  set chosenInventory(InventoryListingStruct value) {
    _chosenInventory = value;
  }

  void updateChosenInventoryStruct(Function(InventoryListingStruct) updateFn) {
    updateFn(_chosenInventory);
  }

  OrderListsStruct _chosenOrder = OrderListsStruct();
  OrderListsStruct get chosenOrder => _chosenOrder;
  set chosenOrder(OrderListsStruct value) {
    _chosenOrder = value;
  }

  void updateChosenOrderStruct(Function(OrderListsStruct) updateFn) {
    updateFn(_chosenOrder);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
