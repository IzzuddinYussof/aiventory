import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_h_q_model.dart';
export 'dashboard_h_q_model.dart';

class DashboardHQWidget extends StatefulWidget {
  const DashboardHQWidget({super.key});

  static String routeName = 'dashboardHQ';
  static String routePath = '/dashboardHQ';

  @override
  State<DashboardHQWidget> createState() => _DashboardHQWidgetState();
}

class _DashboardHQWidgetState extends State<DashboardHQWidget>
    with TickerProviderStateMixin {
  late DashboardHQModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  final animationsMap = <String, AnimationInfo>{};

  void _setLoading(bool value) {
    _isLoading = value;
    safeSetState(() {});
  }

  Future<void> _loadDashboard() async {
    _setLoading(true);
    try {
      if (FFAppState().activeBranchFilterId != null) {
        _model.dashboardDataBranch = await DashboardGroup.dashboardHQCall.call(
          access: FFAppState().user.access,
          branchId: FFAppState().activeBranchFilterIdString,
        );

        if ((_model.dashboardDataBranch?.succeeded ?? true)) {
          FFAppState().DashboardHQ = DashboardHQDataStruct.maybeFromMap(
            (_model.dashboardDataBranch?.jsonBody ?? ''),
          )!;
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Error Dashboard Data'),
                content: Text(
                  getJsonField(
                    (_model.dashboardDataBranch?.jsonBody ?? ''),
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
        _model.dashboardDataHQ = await DashboardGroup.dashboardHQCall.call(
          access: FFAppState().user.access,
        );

        if ((_model.dashboardDataHQ?.succeeded ?? true)) {
          FFAppState().DashboardHQ = DashboardHQDataStruct.maybeFromMap(
            (_model.dashboardDataHQ?.jsonBody ?? ''),
          )!;
          safeSetState(() {});
        } else {
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Error Dashboard Data'),
                content: Text(
                  getJsonField(
                    (_model.dashboardDataHQ?.jsonBody ?? ''),
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
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardHQModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadDashboard();
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 170.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 170.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 90.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where(
        (anim) =>
            anim.trigger == AnimationTrigger.onActionTrigger ||
            !anim.applyInitialState,
      ),
      this,
    );

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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 44.0, 16.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: FlutterFlowTheme.of(context).primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image.network(
                                FFAppState().user.profilePic.url,
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              14.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFAppState().user.nickname,
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).titleLarge.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).titleLarge.fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).titleLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).titleLarge.fontStyle,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    FFAppState().user.role,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 30.0,
                          fillColor: FlutterFlowTheme.of(context).accent1,
                          icon: Icon(
                            Icons.logout,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 15.0,
                          ),
                          onPressed: () async {
                            FFAppState().token = '';
                            FFAppState().user = UserStruct();
                            FFAppState().branch = '';
                            FFAppState().branchId = 0;
                            FFAppState().orderLists = [];
                            FFAppState().Toggle = false;
                            FFAppState().DashboardHQ = DashboardHQDataStruct();
                            FFAppState().processing = false;
                            FFAppState().branchIdUser = 0;
                            FFAppState().chosenInventory =
                                InventoryListingStruct();
                            safeSetState(() {});

                            context.pushNamed(LoginWidget.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (FFAppState().user.branch == 'AI Venture')
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: FlutterFlowDropDown<int>(
                                controller: _model.branchValueController ??=
                                    FormFieldController<int>(
                                  _model.branchValue ??= FFAppState().branchId,
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
                                  safeSetState(() => _model.branchValue = val);
                                  if (val == null) {
                                    return;
                                  }
                                  FFAppState().setActiveBranchById(
                                    val,
                                    notify: false,
                                  );
                                  await _loadDashboard();
                                  safeSetState(() {});
                                },
                                width: double.infinity,
                                height: 35.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).bodySmall.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodySmall.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).bodySmall.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).bodySmall.fontStyle,
                                    ),
                                hintText: 'Select Branch',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 1.0,
                                borderRadius: 12.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (FFAppState().user.branch == 'AI Venture')
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              16.0,
                              16.0,
                              0.0,
                            ),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context
                                    .pushNamed(EditInventoryWidget.routeName);
                              },
                              text: 'Add Inventory',
                              options: FFButtonOptions(
                                height: 30.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0,
                                  0.0,
                                  16.0,
                                  0.0,
                                ),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  0.0,
                                  0.0,
                                  0.0,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
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
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                    ].addToEnd(SizedBox(width: 9.0)),
                  ),
                  if (responsiveVisibility(
                    context: context,
                    tabletLandscape: false,
                    desktop: false,
                  ))
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.0,
                        20.0,
                        16.0,
                        12.0,
                      ),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(FindInventoryWidget.routeName);
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 160.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).secondaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.interests,
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primaryText,
                                      size: 32.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        12.0,
                                        0.0,
                                        12.0,
                                      ),
                                      child: Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            FFAppState()
                                                .DashboardHQ
                                                .totalInventory,
                                            formatType: FormatType.decimal,
                                            decimalType: DecimalType.automatic,
                                          ),
                                          'Loading...',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontStyle,
                                              ),
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'Items',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation1']!,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(OrderWidget.routeName);
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 160.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).success,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.cartArrowDown,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 33.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        12.0,
                                        0.0,
                                        12.0,
                                      ),
                                      child: Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            FFAppState().DashboardHQ.orderCount,
                                            formatType: FormatType.decimal,
                                            decimalType: DecimalType.automatic,
                                          ),
                                          'Loading...',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontStyle,
                                              ),
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).info,
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'New Order',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation2']!,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                FindInventoryWidget.routeName,
                                queryParameters: {
                                  'expiryDate': serializeParam(
                                    functions.addDate(14),
                                    ParamType.DateTime,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 160.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).error,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.shoppingBasket,
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primaryText,
                                      size: 32.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        12.0,
                                        0.0,
                                        12.0,
                                      ),
                                      child: Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            FFAppState().DashboardHQ.expiring,
                                            formatType: FormatType.decimal,
                                            decimalType: DecimalType.automatic,
                                          ),
                                          'Loading...',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'Expiring Item',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation3']!,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                OrderListWidget.routeName,
                                queryParameters: {
                                  'days':
                                      serializeParam('28', ParamType.String),
                                }.withoutNulls,
                              );
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 160.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).warning,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline_sharp,
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primaryText,
                                      size: 32.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        12.0,
                                        0.0,
                                        12.0,
                                      ),
                                      child: Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            FFAppState().DashboardHQ.orderLate,
                                            formatType: FormatType.decimal,
                                            decimalType: DecimalType.automatic,
                                          ),
                                          'Loading...',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).displaySmall.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).displaySmall.fontStyle,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'Slow Order',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation4']!,
                          ),
                        ],
                      ),
                    ),
                  if (responsiveVisibility(
                    context: context,
                    phone: false,
                    tablet: false,
                  ))
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              60.0,
                              0.0,
                              60.0,
                              0.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      FindInventoryWidget.routeName,
                                    );
                                  },
                                  child: Container(
                                    width: 400.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).secondaryBackground,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.interests,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              12.0,
                                              0.0,
                                              12.0,
                                            ),
                                            child: Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  FFAppState()
                                                      .DashboardHQ
                                                      .totalInventory,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.automatic,
                                                ),
                                                'Loading...',
                                              ),
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Items',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                  animationsMap[
                                      'containerOnPageLoadAnimation5']!,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(OrderWidget.routeName);
                                  },
                                  child: Container(
                                    width: 400.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.cartArrowDown,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).info,
                                            size: 33.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              12.0,
                                              0.0,
                                              12.0,
                                            ),
                                            child: Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  FFAppState()
                                                      .DashboardHQ
                                                      .orderCount,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.automatic,
                                                ),
                                                'Loading...',
                                              ),
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).info,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'New Order',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                  animationsMap[
                                      'containerOnPageLoadAnimation6']!,
                                ),
                              ].divide(SizedBox(width: 20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              60.0,
                              0.0,
                              60.0,
                              0.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      FindInventoryWidget.routeName,
                                      queryParameters: {
                                        'expiryDate': serializeParam(
                                          functions.addDate(14),
                                          ParamType.DateTime,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: 400.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).error,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.shoppingBasket,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              12.0,
                                              0.0,
                                              12.0,
                                            ),
                                            child: Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  FFAppState()
                                                      .DashboardHQ
                                                      .expiring,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.automatic,
                                                ),
                                                'Loading...',
                                              ),
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Expiring Item',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                  animationsMap[
                                      'containerOnPageLoadAnimation7']!,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      OrderListWidget.routeName,
                                      queryParameters: {
                                        'days': serializeParam(
                                          '28',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: 400.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).warning,
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline_sharp,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              12.0,
                                              0.0,
                                              12.0,
                                            ),
                                            child: Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  FFAppState()
                                                      .DashboardHQ
                                                      .orderLate,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.automatic,
                                                ),
                                                'Loading...',
                                              ),
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).displaySmall.fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).displaySmall.fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Slow Order',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ).animateOnPageLoad(
                                  animationsMap[
                                      'containerOnPageLoadAnimation8']!,
                                ),
                              ].divide(SizedBox(width: 20.0)),
                            ),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
                    ),
                ],
              ),
            ),
            if (_isLoading)
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
    );
  }
}
