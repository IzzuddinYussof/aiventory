import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'stock_in_model.dart';
export 'stock_in_model.dart';

class StockInWidget extends StatefulWidget {
  const StockInWidget({
    super.key,
    this.orderData,
  });

  final OrderListsStruct? orderData;

  static String routeName = 'StockIn';
  static String routePath = '/stockIn';

  @override
  State<StockInWidget> createState() => _StockInWidgetState();
}

class _StockInWidgetState extends State<StockInWidget> {
  late StockInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _unitOptionsForInventory(InventoryStruct? inventory) {
    if (inventory == null) {
      return const [];
    }

    final options = <String>[];
    for (final unit in [inventory.quantityMinor, inventory.quantityMajor]) {
      if (unit.isNotEmpty && !options.contains(unit)) {
        options.add(unit);
      }
    }
    return options;
  }

  void _applyInventorySelection(InventoryStruct? inventory) {
    _model.inventoryChosen = inventory;
    _model.inventoryOptionLists = [];
    _model.unitOptions = _unitOptionsForInventory(inventory);
    _model.dropDownUnitValue =
        _model.unitOptions.isNotEmpty ? _model.unitOptions.first : null;

    if (_model.dropDownUnitValue != null) {
      _model.dropDownUnitValueController ??=
          FormFieldController<String>(_model.dropDownUnitValue);
      _model.dropDownUnitValueController?.value = _model.dropDownUnitValue;
    } else {
      _model.dropDownUnitValueController?.reset();
    }

    safeSetState(() {});
  }

  Future<void> _showUnitRequiredDialog() async {
    final message = _model.unitOptions.isEmpty
        ? 'The selected inventory has no configured unit. Set up the inventory unit first.'
        : 'Please choose a unit before saving stock in.';

    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text('Unit Required'),
          content: Text(message),
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StockInModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _applyInventorySelection(widget.orderData?.inventory);
      safeSetState(() {
        _model.typeTextController?.text = 'Stock In';
      });
      if (widget.orderData != null) {
        safeSetState(() {
          _model.quantityTextController?.text =
              widget.orderData!.quantityOrdered.toString();
        });
      }
    });

    _model.searchTextController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
    _model.searchFocusNode!.addListener(() => safeSetState(() {}));
    _model.typeTextController ??= TextEditingController(text: 'Stock In');
    _model.typeFocusNode ??= FocusNode();
    _model.typeFocusNode!.addListener(() => safeSetState(() {}));
    _model.quantityTextController ??= TextEditingController();
    _model.quantityFocusNode ??= FocusNode();
    _model.quantityFocusNode!.addListener(() => safeSetState(() {}));
    _model.unitCostTextController ??= TextEditingController();
    _model.unitCostFocusNode ??= FocusNode();
    _model.unitCostFocusNode!.addListener(() => safeSetState(() {}));
    _model.totalCostTextController ??= TextEditingController();
    _model.totalCostFocusNode ??= FocusNode();
    _model.totalCostFocusNode!.addListener(() => safeSetState(() {}));
    _model.remarkTextController ??= TextEditingController();
    _model.remarkFocusNode ??= FocusNode();
    _model.remarkFocusNode!.addListener(() => safeSetState(() {}));
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
            'Stock In',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: TextFormField(
                                  controller: _model.searchTextController,
                                  focusNode: _model.searchFocusNode,
                                  onFieldSubmitted: (_) async {
                                    if (_model.searchTextController.text !=
                                            null &&
                                        _model.searchTextController.text !=
                                            '') {
                                      _model.findInventoryEnter =
                                          await InventoryGroup.inventoryCall
                                              .call(
                                        name: _model.searchTextController.text,
                                      );

                                      if ((_model
                                              .findInventoryEnter?.succeeded ??
                                          true)) {
                                        _model.inventoryOptionLists = ((_model
                                                            .findInventoryEnter
                                                            ?.jsonBody ??
                                                        '')
                                                    .toList()
                                                    .map<InventoryStruct?>(
                                                        InventoryStruct
                                                            .maybeFromMap)
                                                    .toList()
                                                as Iterable<InventoryStruct?>)
                                            .withoutNulls
                                            .toList()
                                            .cast<InventoryStruct>();
                                        safeSetState(() {});
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Error Finding Inventory'),
                                              content: Text(getJsonField(
                                                (_model.findInventoryEnter
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.message''',
                                              ).toString()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please insert the item name',
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    }

                                    safeSetState(() {});
                                  },
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    labelText: 'Search ..',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                    alignLabelWithHint: false,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            24.0, 12.0, 12.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model
                                      .searchTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_model.searchTextController.text != null &&
                                    _model.searchTextController.text != '') {
                                  _model.findInventory =
                                      await InventoryGroup.inventoryCall.call(
                                    name: _model.searchTextController.text,
                                  );

                                  if ((_model.findInventory?.succeeded ??
                                      true)) {
                                    _model.inventoryOptionLists =
                                        ((_model.findInventory?.jsonBody ?? '')
                                                    .toList()
                                                    .map<InventoryStruct?>(
                                                        InventoryStruct
                                                            .maybeFromMap)
                                                    .toList()
                                                as Iterable<InventoryStruct?>)
                                            .withoutNulls
                                            .toList()
                                            .cast<InventoryStruct>();
                                    safeSetState(() {});
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title:
                                              Text('Error Finding Inventory'),
                                          content: Text(getJsonField(
                                            (_model.findInventory?.jsonBody ??
                                                ''),
                                            r'''$.message''',
                                          ).toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please insert the item name',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                }

                                safeSetState(() {});
                              },
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: FlutterFlowTheme.of(context).accent2,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.barcode =
                                    await FlutterBarcodeScanner.scanBarcode(
                                  '#C62828', // scanning line color
                                  'Cancel', // cancel button text
                                  true, // whether to show the flash icon
                                  ScanMode.QR,
                                );

                                _model.findBarcode = await InventoryGroup
                                    .inventoryFindBarcodeCall
                                    .call(
                                  barcode: _model.barcode,
                                );

                                if ((_model.findBarcode?.succeeded ?? true)) {
                                  FFAppState().inventoryCurrent =
                                      InventoryStruct.maybeFromMap(
                                          (_model.findBarcode?.jsonBody ??
                                              ''))!;
                                  _applyInventorySelection(
                                      FFAppState().inventoryCurrent);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Error Finding Barcode'),
                                        content: Text(getJsonField(
                                          (_model.findBarcode?.jsonBody ?? ''),
                                          r'''$.message''',
                                        ).toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                safeSetState(() {});
                              },
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: FlutterFlowTheme.of(context).warning,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                        .divide(SizedBox(height: 16.0))
                        .addToStart(SizedBox(height: 12.0)),
                  ),
                  if (_model.inventoryOptionLists.isNotEmpty)
                    Builder(
                      builder: (context) {
                        final inventoryOptions =
                            _model.inventoryOptionLists.toList();

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: inventoryOptions.length,
                          itemBuilder: (context, inventoryOptionsIndex) {
                            final inventoryOptionsItem =
                                inventoryOptions[inventoryOptionsIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _applyInventorySelection(
                                      inventoryOptionsItem);
                                },
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    inventoryOptionsItem.itemName,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  Text(
                    'Item Name : ${_model.inventoryChosen?.itemName}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.typeTextController,
                    focusNode: _model.typeFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    readOnly: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      hintText: 'Type',
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      errorStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).error,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: (_model.typeFocusNode?.hasFocus ?? false)
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 20.0, 16.0, 20.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator:
                        _model.typeTextControllerValidator.asValidator(context),
                    inputFormatters: [
                      if (!isAndroid && !isiOS)
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            selection: newValue.selection,
                            text: newValue.text
                                .toCapitalization(TextCapitalization.words),
                          );
                        }),
                    ],
                  ),
                  if (_model.inventoryChosen?.expiry ?? true)
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        final _datePickedDate = await showDatePicker(
                          context: context,
                          initialDate: getCurrentTimestamp,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2050),
                          builder: (context, child) {
                            return wrapInMaterialDatePickerTheme(
                              context,
                              child!,
                              headerBackgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              headerForegroundColor:
                                  FlutterFlowTheme.of(context).info,
                              headerTextStyle: FlutterFlowTheme.of(context)
                                  .headlineLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineLarge
                                          .fontStyle,
                                    ),
                                    fontSize: 32.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .fontStyle,
                                  ),
                              pickerBackgroundColor:
                                  FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              pickerForegroundColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              selectedDateTimeBackgroundColor:
                                  FlutterFlowTheme.of(context).accent2,
                              selectedDateTimeForegroundColor:
                                  FlutterFlowTheme.of(context).info,
                              actionButtonForegroundColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              iconSize: 24.0,
                            );
                          },
                        );

                        if (_datePickedDate != null) {
                          safeSetState(() {
                            _model.datePicked = DateTime(
                              _datePickedDate.year,
                              _datePickedDate.month,
                              _datePickedDate.day,
                            );
                          });
                        } else if (_model.datePicked != null) {
                          safeSetState(() {
                            _model.datePicked = getCurrentTimestamp;
                          });
                        }
                        _model.expiryDate =
                            dateTimeFormat("y-MM-dd", _model.datePicked);
                        safeSetState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 0.0, 16.0),
                          child: Text(
                            _model.expiryDate,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _model.quantityTextController,
                          focusNode: _model.quantityFocusNode,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            errorStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor:
                                (_model.quantityFocusNode?.hasFocus ?? false)
                                    ? FlutterFlowTheme.of(context).accent1
                                    : FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 20.0),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          cursorColor: FlutterFlowTheme.of(context).primary,
                          validator: _model.quantityTextControllerValidator
                              .asValidator(context),
                          inputFormatters: [
                            if (!isAndroid && !isiOS)
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return TextEditingValue(
                                  selection: newValue.selection,
                                  text: newValue.text.toCapitalization(
                                      TextCapitalization.words),
                                );
                              }),
                          ],
                        ),
                      ),
                      FlutterFlowDropDown<String>(
                        controller: _model.dropDownUnitValueController ??=
                            FormFieldController<String>(null),
                        options: _model.unitOptions,
                        onChanged: (val) =>
                            safeSetState(() => _model.dropDownUnitValue = val),
                        width: 150.0,
                        height: 50.0,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                        hintText: 'Choose unit',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).alternate,
                        borderWidth: 2.0,
                        borderRadius: 12.0,
                        margin:
                            EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 8.0, 4.0),
                        hidesUnderline: true,
                        isOverButton: true,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ].divide(SizedBox(width: 6.0)),
                  ),
                  TextFormField(
                    controller: _model.unitCostTextController,
                    focusNode: _model.unitCostFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Cost per Unit',
                      labelStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      errorStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).error,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: (_model.unitCostFocusNode?.hasFocus ?? false)
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 20.0, 16.0, 20.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator: _model.unitCostTextControllerValidator
                        .asValidator(context),
                    inputFormatters: [
                      if (!isAndroid && !isiOS)
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            selection: newValue.selection,
                            text: newValue.text
                                .toCapitalization(TextCapitalization.words),
                          );
                        }),
                    ],
                  ),
                  TextFormField(
                    controller: _model.totalCostTextController,
                    focusNode: _model.totalCostFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Total Cost',
                      labelStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      hintStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      errorStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).error,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: (_model.totalCostFocusNode?.hasFocus ?? false)
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 20.0, 16.0, 20.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator: _model.totalCostTextControllerValidator
                        .asValidator(context),
                    inputFormatters: [
                      if (!isAndroid && !isiOS)
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            selection: newValue.selection,
                            text: newValue.text
                                .toCapitalization(TextCapitalization.words),
                          );
                        }),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.remarkTextController,
                      focusNode: _model.remarkFocusNode,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Remark',
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: (_model.remarkFocusNode?.hasFocus ?? false)
                            ? FlutterFlowTheme.of(context).accent1
                            : FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      enableInteractiveSelection: false,
                      validator: _model.remarkTextControllerValidator
                          .asValidator(context),
                      inputFormatters: [
                        if (!isAndroid && !isiOS)
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            return TextEditingValue(
                              selection: newValue.selection,
                              text: newValue.text.toCapitalization(
                                  TextCapitalization.sentences),
                            );
                          }),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_model.uploadedImage == null ||
                              (_model.uploadedImage?.bytes?.isEmpty ?? true))
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final selectedMedia =
                                        await selectMediaWithSourceBottomSheet(
                                      context: context,
                                      allowPhoto: true,
                                    );
                                    if (selectedMedia != null &&
                                        selectedMedia.every((m) =>
                                            validateFileFormat(
                                                m.storagePath, context))) {
                                      safeSetState(() => _model
                                              .isDataUploading_uploadDataLocal =
                                          true);
                                      var selectedUploadedFiles =
                                          <FFUploadedFile>[];

                                      try {
                                        selectedUploadedFiles = selectedMedia
                                            .map((m) => FFUploadedFile(
                                                  name: m.storagePath
                                                      .split('/')
                                                      .last,
                                                  bytes: m.bytes,
                                                  height: m.dimensions?.height,
                                                  width: m.dimensions?.width,
                                                  blurHash: m.blurHash,
                                                  originalFilename:
                                                      m.originalFilename,
                                                ))
                                            .toList();
                                      } finally {
                                        _model.isDataUploading_uploadDataLocal =
                                            false;
                                      }
                                      if (selectedUploadedFiles.length ==
                                          selectedMedia.length) {
                                        safeSetState(() {
                                          _model.uploadedLocalFile_uploadDataLocal =
                                              selectedUploadedFiles.first;
                                        });
                                      } else {
                                        safeSetState(() {});
                                        return;
                                      }
                                    }

                                    _model.uploadedImage = _model
                                        .uploadedLocalFile_uploadDataLocal;
                                    safeSetState(() {});
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      Text(
                                        'Click to upload picture',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            ),
                          if (_model.uploadedImage != null &&
                              (_model.uploadedImage?.bytes?.isNotEmpty ??
                                  false))
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0x00FFFFFF),
                                    ),
                                    child: Visibility(
                                      visible: _model.uploadedImage != null &&
                                          (_model.uploadedImage?.bytes
                                                  ?.isNotEmpty ??
                                              false),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.memory(
                                          _model.uploadedImage?.bytes ??
                                              Uint8List.fromList([]),
                                          width: 150.0,
                                          height: 150.0,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.94, -0.95),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          _model.uploadedImage = null;
                                          safeSetState(() {});
                                        },
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        final selectedUnit = _model.dropDownUnitValue;

                        if ((_model.inventoryChosen != null) &&
                            (_model.quantityTextController.text != null &&
                                _model.quantityTextController.text != '')) {
                          if (selectedUnit == null || selectedUnit.isEmpty) {
                            await _showUnitRequiredDialog();
                            return;
                          }

                          await Future.wait([
                            Future(() async {
                              if (_model.uploadedImage != null &&
                                  (_model.uploadedImage?.bytes?.isNotEmpty ??
                                      false)) {
                                _model.uploadedFile = await UploadFileCall.call(
                                  mainFolder: FFAppState().branch,
                                  subFolder: _model.inventoryChosen?.itemName,
                                  file: _model.uploadedImage,
                                );

                                if ((_model.uploadedFile?.succeeded ?? true)) {
                                  _model.fileURL = FileStruct.maybeFromMap(
                                          (_model.uploadedFile?.jsonBody ?? ''))
                                      ?.viewUrl;
                                  safeSetState(() {});
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Error uploading file'),
                                        content: Text(getJsonField(
                                          (_model.uploadedFile?.jsonBody ?? ''),
                                          r'''$.message''',
                                        ).toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                              _model.saveInventoryMovement =
                                  await InventoryMovementGroup
                                      .inventoryMovementPostCall
                                      .call(
                                inventoryId: _model.inventoryChosen?.id,
                                branch: FFAppState().user.branch,
                                expiryDate: _model.expiryDate,
                                quantity: double.tryParse(
                                    _model.quantityTextController.text),
                                unit: selectedUnit,
                                note: _model.remarkTextController.text,
                                orderListId: valueOrDefault<int>(
                                  widget!.orderData?.id,
                                  0,
                                ),
                                updateName: FFAppState().user.name,
                                updateTimestamp:
                                    getCurrentTimestamp.millisecondsSinceEpoch,
                                unitCost: double.tryParse(
                                    _model.unitCostTextController.text),
                                totalCost: double.tryParse(
                                    _model.totalCostTextController.text),
                                txType: _model.typeTextController.text,
                                updateBranch: FFAppState().branch,
                                doc: _model.fileURL,
                              );

                              if ((_model.saveInventoryMovement?.succeeded ??
                                  true)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Stock movement recorded successfully',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                                safeSetState(() {
                                  _model.totalCostTextController?.clear();
                                  _model.unitCostTextController?.clear();
                                  _model.quantityTextController?.clear();
                                  _model.searchTextController?.clear();
                                  _model.remarkTextController?.clear();
                                });
                                safeSetState(() {
                                  _model.dropDownUnitValueController?.reset();
                                  _model.dropDownUnitValue = null;
                                });
                                _model.inventoryChosen = null;
                                _model.expiryDate = 'Expiry Date';
                                _model.uploadedImage = null;
                                _model.fileURL = null;
                                safeSetState(() {});
                                if (widget!.orderData != null) {
                                  context.safePop();
                                }
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text(
                                          'Error saving inventory movement'),
                                      content: Text(getJsonField(
                                        (_model.saveInventoryMovement
                                                ?.jsonBody ??
                                            ''),
                                        r'''$.message''',
                                      ).toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }),
                            Future(() async {
                              if (widget!.orderData != null) {
                                _model.updateReceived =
                                    await OrderGroup.orderStatusUpdateCall.call(
                                  id: widget!.orderData?.id,
                                  status: 'received',
                                  name: FFAppState().user.name,
                                  remark: _model.remarkTextController.text,
                                );

                                if (!(_model.updateReceived?.succeeded ??
                                    true)) {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Error update received'),
                                        content: Text(getJsonField(
                                          (_model.updateReceived?.jsonBody ??
                                              ''),
                                          r'''$.message''',
                                        ).toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            }),
                          ]);
                        } else {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Please choose the item and fill in the required info'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        safeSetState(() {});
                      },
                      text: 'Save',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 54.0,
                        padding: EdgeInsets.all(0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 4.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ]
                    .divide(SizedBox(height: 12.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
