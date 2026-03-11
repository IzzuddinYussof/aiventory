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
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'find_inventory_model.dart';
export 'find_inventory_model.dart';

class FindInventoryWidget extends StatefulWidget {
  const FindInventoryWidget({super.key, this.expiryDate});

  final DateTime? expiryDate;

  static String routeName = 'findInventory';
  static String routePath = '/findInventory';

  @override
  State<FindInventoryWidget> createState() => _FindInventoryWidgetState();
}

class _FindInventoryWidgetState extends State<FindInventoryWidget> {
  late FindInventoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 1;
  int _pageTotal = 1;
  int _perPage = 25;
  int _itemsTotal = 0;
  int? _nextPage;
  int? _prevPage;
  bool _isPageLoading = false;
  bool _isPaginationLoading = false;
  List<int>? _activeInventoryIdList;
  final Map<int, InventoryStruct> _inventoryLookup = {};

  Future<void> _runWithPageLoading(Future<void> Function() action) async {
    if (_isPageLoading) {
      return;
    }
    _isPageLoading = true;
    safeSetState(() {});
    try {
      await action();
    } finally {
      _isPageLoading = false;
      safeSetState(() {});
    }
  }

  List<InventoryListingStruct> _parseInventoryListingItems(
    dynamic responseBody,
  ) {
    final itemsJson = getJsonField(responseBody, r'''$.items''');
    final source = itemsJson is List
        ? itemsJson
        : (responseBody is List ? responseBody : <dynamic>[]);

    return source
        .map<InventoryListingStruct?>((item) {
          if (item is! Map) {
            return null;
          }

          final itemMap = item.cast<String, dynamic>();
          final listing = InventoryListingStruct.maybeFromMap(itemMap);
          if (listing == null) {
            return null;
          }

          final inlineInventory =
              InventoryStruct.maybeFromMap(itemMap['items']);
          final shouldHydrateInventory = !listing.hasInventory() ||
              listing.inventory.id == 0 ||
              listing.inventory.itemName.isEmpty;

          if (shouldHydrateInventory && inlineInventory != null) {
            listing.inventory = inlineInventory;
          }

          if ((listing.inventory.id == 0 ||
                  listing.inventory.itemName.isEmpty) &&
              _inventoryLookup.containsKey(listing.inventoryId)) {
            listing.inventory = _inventoryLookup[listing.inventoryId];
          }

          return listing;
        })
        .withoutNulls
        .toList()
        .cast<InventoryListingStruct>();
  }

  List<int> _parseInventoryIds(dynamic responseBody) {
    final source = _parseInventorySource(responseBody);

    return source
        .map<InventoryStruct?>(InventoryStruct.maybeFromMap)
        .withoutNulls
        .map((e) => e.id)
        .where((id) => id != 0)
        .toList();
  }

  List<dynamic> _parseInventorySource(dynamic responseBody) {
    if (responseBody is List) {
      return responseBody;
    }
    final itemsJson = getJsonField(responseBody, r'''$.items''');
    if (itemsJson is List) {
      return itemsJson;
    }
    return <dynamic>[];
  }

  void _cacheInventoryLookup(dynamic responseBody) {
    final inventoryList = _parseInventorySource(responseBody)
        .map<InventoryStruct?>(InventoryStruct.maybeFromMap)
        .withoutNulls;

    for (final inventory in inventoryList) {
      if (inventory.id != 0) {
        _inventoryLookup[inventory.id] = inventory;
      }
    }
  }

  int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  void _applyPagingState(dynamic responseBody) {
    final paging = getJsonField(responseBody, r'''$.paging''');
    final page = _asInt(getJsonField(paging, r'''$.page''')) ??
        _asInt(getJsonField(responseBody, r'''$.curPage''')) ??
        _asInt(getJsonField(responseBody, r'''$.page''')) ??
        1;
    final perPage = _asInt(getJsonField(paging, r'''$.per_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.perPage''')) ??
        _perPage;
    final itemsTotal = _asInt(getJsonField(paging, r'''$.items_total''')) ??
        _asInt(getJsonField(responseBody, r'''$.itemsTotal''')) ??
        _asInt(getJsonField(responseBody, r'''$.itemsReceived''')) ??
        _itemsTotal;
    final pageTotal = _asInt(getJsonField(paging, r'''$.page_total''')) ??
        _asInt(getJsonField(responseBody, r'''$.pageTotal''')) ??
        _pageTotal;
    final nextPage = _asInt(getJsonField(paging, r'''$.next_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.nextPage'''));
    final prevPage = _asInt(getJsonField(paging, r'''$.prev_page''')) ??
        _asInt(getJsonField(responseBody, r'''$.prevPage'''));

    _currentPage = page > 0 ? page : 1;
    _perPage = perPage > 0 ? perPage : 25;
    _itemsTotal = itemsTotal >= 0 ? itemsTotal : 0;
    _pageTotal = pageTotal > 0
        ? pageTotal
        : (_itemsTotal > 0 && _perPage > 0
            ? ((_itemsTotal + _perPage - 1) ~/ _perPage)
            : 1);
    _nextPage =
        nextPage ?? (_currentPage < _pageTotal ? _currentPage + 1 : null);
    _prevPage = prevPage ?? (_currentPage > 1 ? _currentPage - 1 : null);
  }

  Future<void> _loadInventoryPage(int page) async {
    if (_isPaginationLoading) {
      return;
    }

    _isPaginationLoading = true;
    safeSetState(() {});

    final response = await InventoryListingGroup.inventoryListGetCall.call(
      branchId: FFAppState().branchId,
      inventoryIdList: _activeInventoryIdList,
      expiryDate: _model.chosenDate != null
          ? _model.chosenDate?.millisecondsSinceEpoch
          : 0,
      page: page,
      perPage: _perPage,
    );

    if ((response.succeeded)) {
      _model.inventoryItems = _parseInventoryListingItems(response.jsonBody);
      _applyPagingState(response.jsonBody);
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Error (Inventory Pagination)'),
            content: Text(
              getJsonField(
                (response.jsonBody ?? ''),
                r'''$.message''',
              ).toString(),
            ),
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

    _isPaginationLoading = false;
    safeSetState(() {});
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FindInventoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _runWithPageLoading(() async {
        FFAppState().branch = FFAppState().branch;
        safeSetState(() {});
        _model.chosenDate =
            widget!.expiryDate != null ? widget!.expiryDate : null;
        safeSetState(() {});
        _model.searchInventory = await InventoryGroup.inventoryCall.call(
          name: _model.searchItemTextController.text,
          supplier: _model.searchSupplierTextController.text,
        );

        if ((_model.searchInventory?.succeeded ?? true)) {
          _cacheInventoryLookup(_model.searchInventory?.jsonBody);
          final inventoryIds =
              _parseInventoryIds(_model.searchInventory?.jsonBody);
          _model.listInventoryLoad =
              await InventoryListingGroup.inventoryListGetCall.call(
            branchId: FFAppState().branchId,
            inventoryIdList: inventoryIds,
            expiryDate: _model.chosenDate != null
                ? _model.chosenDate?.millisecondsSinceEpoch
                : 0,
            page: 1,
            perPage: _perPage,
          );

          if ((_model.listInventoryLoad?.succeeded ?? true)) {
            _model.inventoryItems =
                _parseInventoryListingItems(_model.listInventoryLoad?.jsonBody);
            _applyPagingState(_model.listInventoryLoad?.jsonBody);
            _activeInventoryIdList = inventoryIds;
            safeSetState(() {});
          } else {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Error (Inventory List Loading)'),
                  content: Text(
                    getJsonField(
                      (_model.listInventoryLoad?.jsonBody ?? ''),
                      r'''$.message''',
                    ).toString(),
                  ),
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
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Error Search Inventory'),
                content: Text(
                  getJsonField(
                    (_model.searchInventory?.jsonBody ?? ''),
                    r'''$.message''',
                  ).toString(),
                ),
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
      });
    });

    _model.searchItemTextController ??= TextEditingController();
    _model.searchItemFocusNode ??= FocusNode();
    _model.searchItemFocusNode!.addListener(() => safeSetState(() {}));
    _model.searchSupplierTextController ??= TextEditingController();
    _model.searchSupplierFocusNode ??= FocusNode();
    _model.searchSupplierFocusNode!.addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final canGoPrev =
        !_isPaginationLoading && (_prevPage != null || _currentPage > 1);
    final canGoNext = !_isPaginationLoading &&
        (_nextPage != null || _currentPage < _pageTotal);
    final showPaginationControls =
        _pageTotal > 1 || _nextPage != null || _prevPage != null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Find Inventory',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FlutterFlowTheme.of(
                      context,
                    ).headlineMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(
                      context,
                    ).headlineMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight: FlutterFlowTheme.of(
                    context,
                  ).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                16.0,
                                16.0,
                                16.0,
                                16.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextFormField(
                                    controller: _model.searchItemTextController,
                                    focusNode: _model.searchItemFocusNode,
                                    onFieldSubmitted: (_) async {
                                      await _runWithPageLoading(() async {
                                        _model.searchInventorySubmit =
                                            await InventoryGroup.inventoryCall
                                                .call(
                                          name: _model
                                              .searchItemTextController.text,
                                          supplier: _model
                                              .searchSupplierTextController
                                              .text,
                                        );

                                        if ((_model.searchInventorySubmit
                                                ?.succeeded ??
                                            true)) {
                                          _cacheInventoryLookup(
                                            _model.searchInventorySubmit
                                                ?.jsonBody,
                                          );
                                          final inventoryIds =
                                              _parseInventoryIds(
                                            _model.searchInventorySubmit
                                                ?.jsonBody,
                                          );
                                          _model.listInventorySubmit =
                                              await InventoryListingGroup
                                                  .inventoryListGetCall
                                                  .call(
                                            branchId: FFAppState().branchId,
                                            expiryDate:
                                                _model.chosenDate != null
                                                    ? _model.chosenDate
                                                        ?.millisecondsSinceEpoch
                                                    : 0,
                                            inventoryIdList: inventoryIds,
                                            page: 1,
                                            perPage: _perPage,
                                          );

                                          if ((_model.listInventorySubmit
                                                  ?.succeeded ??
                                              true)) {
                                            _model.inventoryItems =
                                                _parseInventoryListingItems(
                                              _model.listInventorySubmit
                                                  ?.jsonBody,
                                            );
                                            _applyPagingState(
                                              _model.listInventorySubmit
                                                  ?.jsonBody,
                                            );
                                            _activeInventoryIdList =
                                                inventoryIds;
                                            safeSetState(() {});
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Error (Inventory List Get Submit)',
                                                  ),
                                                  content: Text(
                                                    getJsonField(
                                                      (_model.listInventorySubmit
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.message''',
                                                    ).toString(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        alertDialogContext,
                                                      ),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Error Search Inventory Submit',
                                                ),
                                                content: Text(
                                                  getJsonField(
                                                    (_model.searchInventorySubmit
                                                            ?.jsonBody ??
                                                        ''),
                                                    r'''$.message''',
                                                  ).toString(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                      alertDialogContext,
                                                    ),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      });
                                    },
                                    autofocus: false,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Search item ...',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                      errorStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).error,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          0.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).primary,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          0.0,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          0.0,
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          0.0,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: (_model.searchItemFocusNode
                                                  ?.hasFocus ??
                                              false)
                                          ? FlutterFlowTheme.of(context).accent1
                                          : FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: (_model.searchItemFocusNode
                                                    ?.hasFocus ??
                                                false)
                                            ? FlutterFlowTheme.of(
                                                context,
                                              ).primary
                                            : FlutterFlowTheme.of(
                                                context,
                                              ).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(
                                      context,
                                    ).primary,
                                    validator: _model
                                        .searchItemTextControllerValidator
                                        .asValidator(context),
                                    inputFormatters: [
                                      if (!isAndroid && !isiOS)
                                        TextInputFormatter.withFunction((
                                          oldValue,
                                          newValue,
                                        ) {
                                          return TextEditingValue(
                                            selection: newValue.selection,
                                            text:
                                                newValue.text.toCapitalization(
                                              TextCapitalization.sentences,
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                  if (FFAppState().user.branch == 'AI Venture')
                                    Container(
                                      width: double.infinity,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0.0,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).alternate,
                                            offset: Offset(0.0, 2.0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0,
                                          0.0,
                                          8.0,
                                          0.0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.other_houses_outlined,
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondaryText,
                                              size: 24.0,
                                            ),
                                            Flexible(
                                              child: FlutterFlowDropDown<int>(
                                                controller: _model
                                                        .branchValueController ??=
                                                    FormFieldController<int>(
                                                  _model.branchValue ??=
                                                      FFAppState().branchId,
                                                ),
                                                options: List<int>.from(
                                                  FFAppState()
                                                      .branchLists
                                                      .map((e) => e.id)
                                                      .toList(),
                                                ),
                                                optionLabels: FFAppState()
                                                    .branchLists
                                                    .map((e) => e.label)
                                                    .toList(),
                                                onChanged: (val) async {
                                                  safeSetState(
                                                    () => _model.branchValue =
                                                        val,
                                                  );
                                                  if (_model.branchValue ==
                                                      null) {
                                                    return;
                                                  }
                                                  FFAppState().branchId =
                                                      _model.branchValue!;
                                                  safeSetState(() {});
                                                  FFAppState().branch =
                                                      FFAppState()
                                                              .branchLists
                                                              .where(
                                                                (e) =>
                                                                    e.id ==
                                                                    FFAppState()
                                                                        .branchId,
                                                              )
                                                              .toList()
                                                              .firstOrNull
                                                              ?.label ??
                                                          '';
                                                  await _runWithPageLoading(
                                                    () async {
                                                      _model.listInventory =
                                                          await InventoryListingGroup
                                                              .inventoryListGetCall
                                                              .call(
                                                        branchId: FFAppState()
                                                            .branchId,
                                                        inventoryIdList:
                                                            _activeInventoryIdList,
                                                        expiryDate: _model
                                                                    .chosenDate !=
                                                                null
                                                            ? _model.chosenDate
                                                                ?.millisecondsSinceEpoch
                                                            : 0,
                                                        page: 1,
                                                        perPage: _perPage,
                                                      );

                                                      if ((_model.listInventory
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model.inventoryItems =
                                                            _parseInventoryListingItems(
                                                          _model.listInventory
                                                              ?.jsonBody,
                                                        );
                                                        _applyPagingState(
                                                          _model.listInventory
                                                              ?.jsonBody,
                                                        );
                                                        safeSetState(() {});
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'Error (Inventory List Get Branch)',
                                                              ),
                                                              content: Text(
                                                                getJsonField(
                                                                  (_model.listInventory
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                  r'''$.message''',
                                                                ).toString(),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator
                                                                          .pop(
                                                                    alertDialogContext,
                                                                  ),
                                                                  child: Text(
                                                                    'Ok',
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  );
                                                  safeSetState(() {});
                                                },
                                                width: double.infinity,
                                                height: 40.0,
                                                textStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                    ),
                                                hintText: 'Select Branch ...',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryText,
                                                  size: 24.0,
                                                ),
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                elevation: 2.0,
                                                borderColor: Colors.transparent,
                                                borderWidth: 0.0,
                                                borderRadius: 8.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                  12.0,
                                                  0.0,
                                                  12.0,
                                                  0.0,
                                                ),
                                                hidesUnderline: true,
                                                isOverButton: false,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (false)
                                    TextFormField(
                                      controller:
                                          _model.searchSupplierTextController,
                                      focusNode: _model.searchSupplierFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Search Supplier ...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontStyle,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).labelMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).labelMedium.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).labelMedium.fontStyle,
                                            ),
                                        errorStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            0.0,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            0.0,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            0.0,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        filled: true,
                                        fillColor: (_model
                                                    .searchSupplierFocusNode
                                                    ?.hasFocus ??
                                                false)
                                            ? FlutterFlowTheme.of(
                                                context,
                                              ).accent1
                                            : FlutterFlowTheme.of(
                                                context,
                                              ).secondaryBackground,
                                        prefixIcon: Icon(
                                          Icons.storefront_outlined,
                                          color: (_model.searchSupplierFocusNode
                                                      ?.hasFocus ??
                                                  false)
                                              ? FlutterFlowTheme.of(
                                                  context,
                                                ).primary
                                              : FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryText,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),
                                      cursorColor: FlutterFlowTheme.of(
                                        context,
                                      ).primary,
                                      validator: _model
                                          .searchSupplierTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  Container(
                                    width: double.infinity,
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0.0,
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).alternate,
                                          offset: Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              8.0,
                                              0.0,
                                              0.0,
                                              0.0,
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final _datePickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).primary,
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).headlineLarge.override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme
                                                                        .of(
                                                                  context,
                                                                )
                                                                    .headlineLarge
                                                                    .fontStyle,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).primary,
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );

                                                if (_datePickedDate != null) {
                                                  safeSetState(() {
                                                    _model.datePicked =
                                                        DateTime(
                                                      _datePickedDate.year,
                                                      _datePickedDate.month,
                                                      _datePickedDate.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                                _model.chosenDate =
                                                    _model.datePicked;
                                                safeSetState(() {});
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.date_range_outlined,
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _model.chosenDate != null
                                                          ? dateTimeFormat(
                                                              "d/M/y",
                                                              _model.chosenDate,
                                                            )
                                                          : 'Select expiry date (if relevant)',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).labelMedium.override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelMedium.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme
                                                                        .of(
                                                                  context,
                                                                )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme
                                                                        .of(
                                                                  context,
                                                                )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                            0.0,
                                            0.0,
                                            20.0,
                                            0.0,
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.chosenDate = null;
                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.close_sharp,
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondaryText,
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      await _runWithPageLoading(() async {
                                        _model.searchInventory =
                                            await InventoryGroup.inventoryCall
                                                .call(
                                          name: _model
                                              .searchItemTextController.text,
                                          supplier: _model
                                              .searchSupplierTextController
                                              .text,
                                        );

                                        if ((_model
                                                .searchInventory?.succeeded ??
                                            true)) {
                                          _cacheInventoryLookup(
                                            _model.searchInventory?.jsonBody,
                                          );
                                          final inventoryIds =
                                              _parseInventoryIds(
                                            _model.searchInventory?.jsonBody,
                                          );
                                          _model.listInventory =
                                              await InventoryListingGroup
                                                  .inventoryListGetCall
                                                  .call(
                                            branchId: FFAppState().branchId,
                                            inventoryIdList: inventoryIds,
                                            expiryDate:
                                                _model.chosenDate != null
                                                    ? _model.chosenDate
                                                        ?.millisecondsSinceEpoch
                                                    : 0,
                                            page: 1,
                                            perPage: _perPage,
                                          );

                                          if ((_model
                                                  .listInventory?.succeeded ??
                                              true)) {
                                            _model.inventoryItems =
                                                _parseInventoryListingItems(
                                              _model.listInventory?.jsonBody,
                                            );
                                            _applyPagingState(
                                              _model.listInventory?.jsonBody,
                                            );
                                            _activeInventoryIdList =
                                                inventoryIds;
                                            safeSetState(() {});
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Error (Inventory List Get)',
                                                  ),
                                                  content: Text(
                                                    getJsonField(
                                                      (_model.listInventory
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.message''',
                                                    ).toString(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        alertDialogContext,
                                                      ),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Error Search Inventory',
                                                ),
                                                content: Text(
                                                  getJsonField(
                                                    (_model.searchInventory
                                                            ?.jsonBody ??
                                                        ''),
                                                    r'''$.message''',
                                                  ).toString(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                      alertDialogContext,
                                                    ),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      });
                                    },
                                    text: 'Find Item',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 48.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0,
                                        0.0,
                                        24.0,
                                        0.0,
                                      ),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).titleSmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).titleSmall.fontStyle,
                                            ),
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontStyle,
                                          ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 12.0)),
                              ),
                            ),
                            if (_model.inventoryOption.isNotEmpty)
                              Container(
                                width: double.infinity,
                                constraints: BoxConstraints(maxHeight: 500.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final inventoryOptions =
                                        _model.inventoryOption.toList();

                                    return SingleChildScrollView(
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                            inventoryOptions.length, (
                                          inventoryOptionsIndex,
                                        ) {
                                          final inventoryOptionsItem =
                                              inventoryOptions[
                                                  inventoryOptionsIndex];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              4.0,
                                              4.0,
                                              4.0,
                                              4.0,
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await _runWithPageLoading(
                                                  () async {
                                                    final inventoryIds = [
                                                      inventoryOptionsItem.id,
                                                    ];
                                                    if (inventoryOptionsItem
                                                            .id !=
                                                        0) {
                                                      _inventoryLookup[
                                                              inventoryOptionsItem
                                                                  .id] =
                                                          inventoryOptionsItem;
                                                    }
                                                    _model.inventoryListing =
                                                        await InventoryListingGroup
                                                            .inventoryListGetCall
                                                            .call(
                                                      branchId:
                                                          FFAppState().branchId,
                                                      inventoryIdList:
                                                          inventoryIds,
                                                      expiryDate:
                                                          valueOrDefault<int>(
                                                        _model.chosenDate
                                                            ?.millisecondsSinceEpoch,
                                                        0,
                                                      ),
                                                      page: 1,
                                                      perPage: _perPage,
                                                    );

                                                    if ((_model.inventoryListing
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.inventoryItems =
                                                          _parseInventoryListingItems(
                                                        _model.inventoryListing
                                                            ?.jsonBody,
                                                      );
                                                      _applyPagingState(
                                                        _model.inventoryListing
                                                            ?.jsonBody,
                                                      );
                                                      _activeInventoryIdList =
                                                          inventoryIds;
                                                      safeSetState(() {});
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Error retrieving inventory list',
                                                            ),
                                                            content: Text(
                                                              getJsonField(
                                                                (_model.inventoryListing
                                                                        ?.jsonBody ??
                                                                    ''),
                                                                r'''$.message''',
                                                              ).toString(),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator
                                                                        .pop(
                                                                  alertDialogContext,
                                                                ),
                                                                child: Text(
                                                                  'Ok',
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }

                                                    _model.inventoryOption = [];
                                                    safeSetState(() {});

                                                    safeSetState(() {});
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    4.0,
                                                  ),
                                                  border: Border.all(
                                                    color: Color(0xFFB0B0B0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                    8.0,
                                                    8.0,
                                                    8.0,
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    inventoryOptionsItem
                                                        .itemName,
                                                    style: FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme
                                                                        .of(
                                                              context,
                                                            )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme
                                                                        .of(
                                                              context,
                                                            )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme
                                                                      .of(
                                                            context,
                                                          )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme
                                                                      .of(
                                                            context,
                                                          )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      if ((_model.inventoryItems.isNotEmpty) == true)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            'List of Items',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyLarge.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).bodyLarge.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).bodyLarge.fontStyle,
                                    ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          8.0,
                          0.0,
                          0.0,
                          0.0,
                        ),
                        child: Text(
                          'Tap any item card to view movement history.',
                          style: FlutterFlowTheme.of(context).labelSmall,
                        ),
                      ),
                      if ((_model.inventoryItems.isNotEmpty) == false)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            'The list is empty',
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).bodyLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyLarge.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).bodyLarge.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).bodyLarge.fontStyle,
                                    ),
                          ),
                        ),

                      // This list view is "shrink wrapped" this can affect your app performance, we would suggest limiting the number of items you query in this list view.
                      //
                      // The list view is shrink wrapped to prevent the page from having two scrollable elements. The parent column is the element that is scrollable and it provides a smooth user experience.
                      Builder(
                        builder: (context) {
                          final inventoryItem = _model.inventoryItems.toList();
                          if (inventoryItem.isEmpty) {
                            return Image.asset(
                              'assets/images/empty_inventory.png',
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 44.0),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: inventoryItem.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.0),
                            itemBuilder: (context, inventoryItemIndex) {
                              final inventoryItemItem =
                                  inventoryItem[inventoryItemIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0,
                                  6.0,
                                  8.0,
                                  6.0,
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final branchLabel = FFAppState()
                                            .branchLists
                                            .where(
                                              (e) =>
                                                  e.id ==
                                                  inventoryItemItem.branchId,
                                            )
                                            .toList()
                                            .firstOrNull
                                            ?.label ??
                                        FFAppState().branch;
                                    await context.pushNamed(
                                      ItemMovementHistoryWidget.routeName,
                                      queryParameters: {
                                        'inventoryId': serializeParam(
                                          inventoryItemItem.inventoryId,
                                          ParamType.int,
                                        ),
                                        'itemName': serializeParam(
                                          inventoryItemItem.inventory.itemName,
                                          ParamType.String,
                                        ),
                                        'branch': serializeParam(
                                          branchLabel,
                                          ParamType.String,
                                        ),
                                        'expiryDate': serializeParam(
                                          inventoryItemItem.expiryDate,
                                          ParamType.int,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 1.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        inventoryItemItem
                                                            .inventory.itemName,
                                                        maxLines: 3,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).titleLarge.override(
                                                                  font: GoogleFonts
                                                                      .interTight(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).titleLarge.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).titleLarge.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).titleLarge.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Branch: ${FFAppState().branchLists.where((e) => e.id == inventoryItemItem.branchId).toList().firstOrNull?.label}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).labelSmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Last Updated: ${dateTimeFormat("d/M/y", functions.timestampToDateTime(inventoryItemItem.lastUpdated))}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).labelSmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Supplier: ${inventoryItemItem.inventory.supplier}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).labelSmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Stock: ${inventoryItemItem.quantityOnHand.toString()}${(String var1) {
                                                          return " (" +
                                                              var1 +
                                                              ")";
                                                        }(inventoryItemItem.inventory.quantityMinor)}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).labelSmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Expiry Date: ${inventoryItemItem.hasExpiryDate() && (inventoryItemItem.expiryDate > 0) ? dateTimeFormat("d/M/y", functions.timestampToDateTime(inventoryItemItem.expiryDate)) : 'No expiry date'}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).labelSmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                          context,
                                                        ).textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Status : ',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).labelSmall.fontWeight,
                                                                      fontStyle:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).labelSmall.fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontWeight,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).labelSmall.fontStyle,
                                                                  ),
                                                            ),
                                                            TextSpan(
                                                              text: 'In Stock',
                                                              style: TextStyle(
                                                                color:
                                                                    FlutterFlowTheme
                                                                        .of(
                                                                  context,
                                                                ).success,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelSmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).labelSmall.fontWeight,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FlutterFlowTheme
                                                                            .of(
                                                                  context,
                                                                )
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                fontStyle:
                                                                    FlutterFlowTheme
                                                                            .of(
                                                                  context,
                                                                )
                                                                        .labelSmall
                                                                        .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 4.0)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                  0.0,
                                                  0.0,
                                                  8.0,
                                                  0.0,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Card(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).primary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          40.0,
                                                        ),
                                                      ),
                                                      child: Visibility(
                                                        visible: inventoryItemItem
                                                                    .inventory
                                                                    .image
                                                                    .url !=
                                                                null &&
                                                            inventoryItemItem
                                                                    .inventory
                                                                    .image
                                                                    .url !=
                                                                '',
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                            2.0,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              40.0,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              inventoryItemItem
                                                                  .inventory
                                                                  .image
                                                                  .url,
                                                              width: 60.0,
                                                              height: 60.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        context.pushNamed(
                                                          OrderWidget.routeName,
                                                          queryParameters: {
                                                            'inventoryId':
                                                                serializeParam(
                                                              inventoryItemItem
                                                                  .inventoryId,
                                                              ParamType.int,
                                                            ),
                                                            'category':
                                                                serializeParam(
                                                              inventoryItemItem
                                                                  .inventory
                                                                  .category,
                                                              ParamType.String,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      text: 'Add Order',
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 15.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        height: 25.0,
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                          0.0,
                                                          0.0,
                                                          0.0,
                                                          0.0,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).accent2,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).bodySmall.fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                      ),
                                                    ),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        FFAppState()
                                                                .chosenInventory =
                                                            inventoryItemItem;
                                                        safeSetState(() {});
                                                      },
                                                      text: 'Stock Out',
                                                      icon: Icon(
                                                        Icons.fmd_bad,
                                                        size: 15.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        height: 25.0,
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                          0.0,
                                                          0.0,
                                                          0.0,
                                                          0.0,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).warning,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).bodySmall.fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                      ),
                                                    ),
                                                    if (FFAppState()
                                                            .user
                                                            .branch ==
                                                        'AI Venture')
                                                      FFButtonWidget(
                                                        onPressed: () async {
                                                          context.goNamed(
                                                            EditInventoryWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'inventoryId':
                                                                  serializeParam(
                                                                inventoryItemItem
                                                                    .inventoryId,
                                                                ParamType.int,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        text: 'Edit Inventory',
                                                        icon: Icon(
                                                          Icons.edit,
                                                          size: 15.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          height: 25.0,
                                                          padding:
                                                              EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme
                                                                  .of(
                                                            context,
                                                          ).accent1,
                                                          textStyle:
                                                              FlutterFlowTheme
                                                                      .of(
                                                            context,
                                                          ).bodySmall.override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodySmall.fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).bodySmall.fontStyle,
                                                                  ),
                                                          elevation: 0.0,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            8.0,
                                                          ),
                                                        ),
                                                      ),
                                                  ].divide(
                                                      SizedBox(height: 6.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ].addToEnd(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      if (showPaginationControls)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color: Color(0x12000000),
                                offset: Offset(0.0, 3.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              12.0,
                              12.0,
                              12.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Page $_currentPage of $_pageTotal',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).titleSmall.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).titleSmall.fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          '$_itemsTotal items total • $_perPage per page',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                    if (_isPaginationLoading)
                                      SizedBox(
                                        width: 18.0,
                                        height: 18.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 42.0,
                                        child: TextButton.icon(
                                          onPressed: canGoPrev
                                              ? () async {
                                                  await _loadInventoryPage(
                                                    _prevPage ??
                                                        (_currentPage - 1),
                                                  );
                                                }
                                              : null,
                                          icon:
                                              Icon(Icons.chevron_left_rounded),
                                          label: Text('Previous'),
                                          style: TextButton.styleFrom(
                                            backgroundColor: canGoPrev
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryBackground
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            foregroundColor: canGoPrev
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: SizedBox(
                                        height: 42.0,
                                        child: TextButton.icon(
                                          onPressed: canGoNext
                                              ? () async {
                                                  await _loadInventoryPage(
                                                    _nextPage ??
                                                        (_currentPage + 1),
                                                  );
                                                }
                                              : null,
                                          icon:
                                              Icon(Icons.chevron_right_rounded),
                                          label: Text('Next'),
                                          style: TextButton.styleFrom(
                                            backgroundColor: canGoNext
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            foregroundColor: canGoNext
                                                ? Colors.white
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
                        ),
                    ].divide(SizedBox(height: 12.0)),
                  ),
                ),
              ),
              if (FFAppState().chosenInventory.inventoryId >= 1)
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: wrapWithModel(
                    model: _model.stockOutWindowModel,
                    updateCallback: () => safeSetState(() {}),
                    child: StockOutWindowWidget(
                      inventoryData: FFAppState().chosenInventory,
                    ),
                  ),
                ),
              if (_isPageLoading)
                Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
