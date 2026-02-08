// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UploadFileStruct extends BaseStruct {
  UploadFileStruct({
    String? name,
    String? blurHash,
    double? width,
    double? height,
    String? bytes,
  })  : _name = name,
        _blurHash = blurHash,
        _width = width,
        _height = height,
        _bytes = bytes;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "blurHash" field.
  String? _blurHash;
  String get blurHash => _blurHash ?? '';
  set blurHash(String? val) => _blurHash = val;

  bool hasBlurHash() => _blurHash != null;

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

  // "bytes" field.
  String? _bytes;
  String get bytes => _bytes ?? '';
  set bytes(String? val) => _bytes = val;

  bool hasBytes() => _bytes != null;

  static UploadFileStruct fromMap(Map<String, dynamic> data) =>
      UploadFileStruct(
        name: data['name'] as String?,
        blurHash: data['blurHash'] as String?,
        width: castToType<double>(data['width']),
        height: castToType<double>(data['height']),
        bytes: data['bytes'] as String?,
      );

  static UploadFileStruct? maybeFromMap(dynamic data) => data is Map
      ? UploadFileStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'blurHash': _blurHash,
        'width': _width,
        'height': _height,
        'bytes': _bytes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'blurHash': serializeParam(
          _blurHash,
          ParamType.String,
        ),
        'width': serializeParam(
          _width,
          ParamType.double,
        ),
        'height': serializeParam(
          _height,
          ParamType.double,
        ),
        'bytes': serializeParam(
          _bytes,
          ParamType.String,
        ),
      }.withoutNulls;

  static UploadFileStruct fromSerializableMap(Map<String, dynamic> data) =>
      UploadFileStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        blurHash: deserializeParam(
          data['blurHash'],
          ParamType.String,
          false,
        ),
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
        bytes: deserializeParam(
          data['bytes'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UploadFileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UploadFileStruct &&
        name == other.name &&
        blurHash == other.blurHash &&
        width == other.width &&
        height == other.height &&
        bytes == other.bytes;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, blurHash, width, height, bytes]);
}

UploadFileStruct createUploadFileStruct({
  String? name,
  String? blurHash,
  double? width,
  double? height,
  String? bytes,
}) =>
    UploadFileStruct(
      name: name,
      blurHash: blurHash,
      width: width,
      height: height,
      bytes: bytes,
    );
