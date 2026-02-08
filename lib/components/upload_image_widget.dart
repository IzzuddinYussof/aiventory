import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'upload_image_model.dart';
export 'upload_image_model.dart';

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({super.key});

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  late UploadImageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadImageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_model.uploadedImage == null ||
                (_model.uploadedImage?.bytes?.isEmpty ?? true))
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
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
                              validateFileFormat(m.storagePath, context))) {
                        safeSetState(
                            () => _model.isDataUploading_uploadData4ah = true);
                        var selectedUploadedFiles = <FFUploadedFile>[];

                        try {
                          selectedUploadedFiles = selectedMedia
                              .map((m) => FFUploadedFile(
                                    name: m.storagePath.split('/').last,
                                    bytes: m.bytes,
                                    height: m.dimensions?.height,
                                    width: m.dimensions?.width,
                                    blurHash: m.blurHash,
                                    originalFilename: m.originalFilename,
                                  ))
                              .toList();
                        } finally {
                          _model.isDataUploading_uploadData4ah = false;
                        }
                        if (selectedUploadedFiles.length ==
                            selectedMedia.length) {
                          safeSetState(() {
                            _model.uploadedLocalFile_uploadData4ah =
                                selectedUploadedFiles.first;
                          });
                        } else {
                          safeSetState(() {});
                          return;
                        }
                      }

                      _model.uploadedImage =
                          _model.uploadedLocalFile_uploadData4ah;
                      safeSetState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        Text(
                          'Click to upload picture',
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
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
                (_model.uploadedImage?.bytes?.isNotEmpty ?? false))
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
                            (_model.uploadedImage?.bytes?.isNotEmpty ?? false),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
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
                      alignment: AlignmentDirectional(0.94, -0.95),
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
                            color: FlutterFlowTheme.of(context).alternate,
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
    );
  }
}
