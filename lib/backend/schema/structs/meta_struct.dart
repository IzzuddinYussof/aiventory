// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetaStruct extends BaseStruct {
  MetaStruct({
    double? width,
    double? height,
  })  : _width = width,
        _height = height;

  // "width" field.
  double? _width;
  double get width => _width ?? 0.0;
  set width(double? val) => _width = val;

  void incrementWidth(double amount) => width = width + amount;

  bool hasWidth() => _width != null;

  // "height" field.
  double? _height;
  double get height => _height ?? 0.0;
  set height(double? val) => _height = val;

  void incrementHeight(double amount) => height = height + amount;

  bool hasHeight() => _height != null;

  static MetaStruct fromMap(Map<String, dynamic> data) => MetaStruct(
        width: castToType<double>(data['width']),
        height: castToType<double>(data['height']),
      );

  static MetaStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'width': _width,
        'height': _height,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'width': serializeParam(
          _width,
          ParamType.double,
        ),
        'height': serializeParam(
          _height,
          ParamType.double,
        ),
      }.withoutNulls;

  static MetaStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetaStruct(
        width: deserializeParam(
          data['width'],
          ParamType.double,
          false,
        ),
        height: deserializeParam(
          data['height'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'MetaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetaStruct &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode => const ListEquality().hash([width, height]);
}

MetaStruct createMetaStruct({
  double? width,
  double? height,
}) =>
    MetaStruct(
      width: width,
      height: height,
    );
