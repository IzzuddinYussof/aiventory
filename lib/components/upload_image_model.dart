import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'upload_image_widget.dart' show UploadImageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadImageModel extends FlutterFlowModel<UploadImageWidget> {
  ///  Local state fields for this component.

  FFUploadedFile? uploadedImage;

  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadData4ah = false;
  FFUploadedFile uploadedLocalFile_uploadData4ah =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
