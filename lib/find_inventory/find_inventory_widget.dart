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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FindInventoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
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
        _model.listInventoryLoad =
            await InventoryListingGroup.inventoryListGetCall.call(
          branchId: FFAppState().branchId,
          inventoryIdList: ((_model.searchInventory?.jsonBody ?? '')
                  .toList()
                  .map<InventoryStruct?>(InventoryStruct.maybeFromMap)
                  .toList() as Iterable<InventoryStruct?>)
              .withoutNulls
              ?.map((e) => e.id)
              .toList(),
          expiryDate: _model.chosenDate != null
              ? _model.chosenDate?.millisecondsSinceEpoch
              : 0,
        );

        if ((_model.listInventoryLoad?.succeeded ?? true)) {
          _model.inventoryItems = ((_model.listInventoryLoad?.jsonBody ?? '')
                  .toList()
                  .map<InventoryListingStruct?>(
                    InventoryListingStruct.maybeFromMap,
                  )
                  .toList() as Iterable<InventoryListingStruct?>)
              .withoutNulls
              .toList()
              .cast<InventoryListingStruct>();
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
                                      _model.searchInventorySubmit =
                                          await InventoryGroup.inventoryCall
                                              .call(
                                        name: _model
                                            .searchItemTextController.text,
                                        supplier: _model
                                            .searchSupplierTextController.text,
                                      );

                                      if ((_model.searchInventorySubmit
                                              ?.succeeded ??
                                          true)) {
                                        _model.listInventorySubmit =
                                            await InventoryListingGroup
                                                .inventoryListGetCall
                                                .call(
                                          branchId: FFAppState().branchId,
                                          expiryDate: _model.chosenDate != null
                                              ? _model.chosenDate
                                                  ?.millisecondsSinceEpoch
                                              : 0,
                                          inventoryIdList:
                                              ((_model.searchInventorySubmit
                                                                  ?.jsonBody ??
                                                              '')
                                                          .toList()
                                                          .map<InventoryStruct?>(
                                                            InventoryStruct
                                                                .maybeFromMap,
                                                          )
                                                          .toList()
                                                      as Iterable<
                                                          InventoryStruct?>)
                                                  .withoutNulls
                                                  ?.map((e) => e.id)
                                                  .toList(),
                                        );

                                        if ((_model.listInventorySubmit
                                                ?.succeeded ??
                                            true)) {
                                          _model.inventoryItems = ((_model
                                                              .listInventorySubmit
                                                              ?.jsonBody ??
                                                          '')
                                                      .toList()
                                                      .map<InventoryListingStruct?>(
                                                        InventoryListingStruct
                                                            .maybeFromMap,
                                                      )
                                                      .toList()
                                                  as Iterable<
                                                      InventoryListingStruct?>)
                                              .withoutNulls
                                              .toList()
                                              .cast<InventoryListingStruct>();
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
                                                  _model.listInventory =
                                                      await InventoryListingGroup
                                                          .inventoryListGetCall
                                                          .call(
                                                    branchId:
                                                        FFAppState().branchId,
                                                    expiryDate: _model
                                                                .chosenDate !=
                                                            null
                                                        ? _model.chosenDate
                                                            ?.millisecondsSinceEpoch
                                                        : 0,
                                                  );

                                                  if ((_model.listInventory
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model
                                                        .inventoryItems = ((_model
                                                                        .listInventory
                                                                        ?.jsonBody ??
                                                                    '')
                                                                .toList()
                                                                .map<
                                                                    InventoryListingStruct?>(
                                                                  InventoryListingStruct
                                                                      .maybeFromMap,
                                                                )
                                                                .toList()
                                                            as Iterable<
                                                                InventoryListingStruct?>)
                                                        .withoutNulls
                                                        .toList()
                                                        .cast<
                                                            InventoryListingStruct>();
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
                                      _model.searchInventory =
                                          await InventoryGroup.inventoryCall
                                              .call(
                                        name: _model
                                            .searchItemTextController.text,
                                        supplier: _model
                                            .searchSupplierTextController.text,
                                      );

                                      if ((_model.searchInventory?.succeeded ??
                                          true)) {
                                        _model.listInventory =
                                            await InventoryListingGroup
                                                .inventoryListGetCall
                                                .call(
                                          branchId: FFAppState().branchId,
                                          inventoryIdList: ((_model
                                                              .searchInventory
                                                              ?.jsonBody ??
                                                          '')
                                                      .toList()
                                                      .map<InventoryStruct?>(
                                                        InventoryStruct
                                                            .maybeFromMap,
                                                      )
                                                      .toList()
                                                  as Iterable<InventoryStruct?>)
                                              .withoutNulls
                                              ?.map((e) => e.id)
                                              .toList(),
                                          expiryDate: _model.chosenDate != null
                                              ? _model.chosenDate
                                                  ?.millisecondsSinceEpoch
                                              : 0,
                                        );

                                        if ((_model.listInventory?.succeeded ??
                                            true)) {
                                          _model.inventoryItems = ((_model
                                                              .listInventory
                                                              ?.jsonBody ??
                                                          '')
                                                      .toList()
                                                      .map<InventoryListingStruct?>(
                                                        InventoryListingStruct
                                                            .maybeFromMap,
                                                      )
                                                      .toList()
                                                  as Iterable<
                                                      InventoryListingStruct?>)
                                              .withoutNulls
                                              .toList()
                                              .cast<InventoryListingStruct>();
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
                                                _model.inventoryListing =
                                                    await InventoryListingGroup
                                                        .inventoryListGetCall
                                                        .call(
                                                  branchId:
                                                      FFAppState().branchId,
                                                  expiryDate:
                                                      valueOrDefault<int>(
                                                    _model.chosenDate
                                                        ?.millisecondsSinceEpoch,
                                                    0,
                                                  ),
                                                );

                                                if ((_model.inventoryListing
                                                        ?.succeeded ??
                                                    true)) {
                                                  _model
                                                      .inventoryItems = ((_model
                                                                      .inventoryListing
                                                                      ?.jsonBody ??
                                                                  '')
                                                              .toList()
                                                              .map<
                                                                  InventoryListingStruct?>(
                                                                InventoryListingStruct
                                                                    .maybeFromMap,
                                                              )
                                                              .toList()
                                                          as Iterable<
                                                              InventoryListingStruct?>)
                                                      .withoutNulls
                                                      .toList()
                                                      .cast<
                                                          InventoryListingStruct>();
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

                                                _model.inventoryOption = [];
                                                safeSetState(() {});

                                                safeSetState(() {});
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
                                                      CrossAxisAlignment.start,
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
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FlutterFlowTheme
                                                                            .of(
                                                                  context,
                                                                )
                                                                        .titleLarge
                                                                        .fontWeight,
                                                                fontStyle:
                                                                    FlutterFlowTheme
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
                                                    RichText(
                                                      textScaler: MediaQuery.of(
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
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Card(
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).primary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                        padding: EdgeInsets.all(
                                                          2.0,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            40.0,
                                                          ),
                                                          child: Image.network(
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
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme
                                                                            .of(
                                                                  context,
                                                                )
                                                                        .bodySmall
                                                                        .fontStyle,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme
                                                                            .of(
                                                                  context,
                                                                )
                                                                        .bodySmall
                                                                        .fontStyle,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                        ).accent1,
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
                                                ].divide(SizedBox(height: 6.0)),
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
                              );
                            },
                          );
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
