import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

Future<bool> ensureConcreteBranchSelected(
  BuildContext context, {
  required String actionLabel,
}) async {
  if (!FFAppState().isAllBranchesSelection) {
    return true;
  }

  await showDialog(
    context: context,
    builder: (alertDialogContext) {
      return AlertDialog(
        title: const Text('Select Branch'),
        content: Text(
          'Choose a specific branch before $actionLabel. '
          '\'All Dentabay\' is only for viewing combined data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );

  return false;
}
