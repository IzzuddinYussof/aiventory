import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

DateTime? timestampToDateTime(int? timestamp) {
  // convert timestamp to datetime format
  if (timestamp == null) return null; // Return null if timestamp is null
  return DateTime.fromMillisecondsSinceEpoch(
      timestamp); // Convert timestamp to DateTime
}

List<InventoryStruct> filterInventory(
  String inputText,
  List<InventoryStruct> data,
) {
  // Filter the data where the property 'item_name' contains the string inputText
  return data.where((item) => item.itemName.contains(inputText)).toList();
}

List<OrderFlowStruct>? orderListOrganize(OrderListsStruct? orderLists) {
  // Early-exit if nothing to do
  if (orderLists == null) return null;

  final List<OrderFlowStruct> flows = [];

  const typeDisplay = <String, String>{
    'submit': 'Submitted',
    'order': 'Ordered',
    'approved': 'Approved',
    'processed': 'Processed',
    'pending': 'Pending',
    'pending_payment': 'Pending payment',
    'cancel': 'Canceled',
    'receive': 'Delivered',
  };

  // Helper: add a stage only when it exists and has a usable date
  void addStage(dynamic stage, String key) {
    if (stage == null) return;

    final rawDate = stage.date; // could be int or DateTime
    DateTime? date;
    if (rawDate is int) {
      date = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is DateTime) {
      date = rawDate;
    }
    if (date == null) return; // skip if no valid date

    flows.add(createOrderFlowStruct(
      type: typeDisplay[key] ?? key,
      name: stage.name ?? '',
      date: date, // DateTime, as requested
      remark: stage.remark ?? '',
    ));
  }

  // Collect each possible status block
  addStage(orderLists.submit, 'submit');
  addStage(orderLists.order, 'order');
  addStage(orderLists.approved, 'approved');
  addStage(orderLists.processed, 'processed');
  addStage(orderLists.pending, 'pending');
  addStage(orderLists.pendingPayment, 'pending_payment');
  addStage(orderLists.cancel, 'cancel');
  addStage(orderLists.receive, 'receive');

  // Sort newest → oldest
  flows
      .sort((a, b) => (b.date ?? DateTime(0)).compareTo(a.date ?? DateTime(0)));

  return flows;
}

UploadFileStruct? imageToJson(FFUploadedFile? files) {
  if (files == null) {
    return null;
  }
  final bytes = files.bytes != null ? base64Encode(files.bytes!) : null;
  final uploadFile = createUploadFileStruct(
    name: files.name,
    blurHash: files.blurHash,
    height: files.height,
    width: files.width,
    bytes: bytes,
  );
  return uploadFile;
}

FFUploadedFile? jsonToImage(UploadFileStruct? jsonFile) {
  if (jsonFile == null) {
    return null;
  }
  if (jsonFile.hasBytes()) {
    return FFUploadedFile(
      name: jsonFile.name,
      bytes: base64.decode(jsonFile.bytes),
      blurHash: jsonFile.blurHash,
      height: jsonFile.height,
      width: jsonFile.width,
    );
  }
  return null;
}

bool checkAccess(
  String? requirement,
  String? access,
) {
  // return true if arguments 2 contains arguments 1
  if (requirement == null || access == null) return false;
  return access.contains(requirement);
}

DateTime shortDatetoDatetime(String shortDate) {
  return DateTime.parse(shortDate);
}

DateTime addDate(int days) {
  // Add / subtract the number of days from the current datetime
  return DateTime.now().add(Duration(days: days));
}

bool dayDifference(
  int timestamp1,
  int timestamp2,
  int days,
) {
  // If days == 0, always return true
  if (days == 0) {
    return true;
  }
  // given two timestamp, and a number of days, determine if the difference between the two dates exceed the number of days. return true if exceeds
  // Convert timestamps to DateTime
  DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
  DateTime date2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);

  // Calculate the difference only if date2 is after date1
  if (date2.isAfter(date1)) {
    Duration difference = date2.difference(date1);
    return difference.inDays > days;
  }

  return false;
}
