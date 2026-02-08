// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FileStruct extends BaseStruct {
  FileStruct({
    String? name,
    String? id,
    String? mimeType,
    String? viewUrl,
    String? downloadUrl,
  })  : _name = name,
        _id = id,
        _mimeType = mimeType,
        _viewUrl = viewUrl,
        _downloadUrl = downloadUrl;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "mime_type" field.
  String? _mimeType;
  String get mimeType => _mimeType ?? '';
  set mimeType(String? val) => _mimeType = val;

  bool hasMimeType() => _mimeType != null;

  // "view_url" field.
  String? _viewUrl;
  String get viewUrl => _viewUrl ?? '';
  set viewUrl(String? val) => _viewUrl = val;

  bool hasViewUrl() => _viewUrl != null;

  // "download_url" field.
  String? _downloadUrl;
  String get downloadUrl => _downloadUrl ?? '';
  set downloadUrl(String? val) => _downloadUrl = val;

  bool hasDownloadUrl() => _downloadUrl != null;

  static FileStruct fromMap(Map<String, dynamic> data) => FileStruct(
        name: data['name'] as String?,
        id: data['id'] as String?,
        mimeType: data['mime_type'] as String?,
        viewUrl: data['view_url'] as String?,
        downloadUrl: data['download_url'] as String?,
      );

  static FileStruct? maybeFromMap(dynamic data) =>
      data is Map ? FileStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'id': _id,
        'mime_type': _mimeType,
        'view_url': _viewUrl,
        'download_url': _downloadUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'mime_type': serializeParam(
          _mimeType,
          ParamType.String,
        ),
        'view_url': serializeParam(
          _viewUrl,
          ParamType.String,
        ),
        'download_url': serializeParam(
          _downloadUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static FileStruct fromSerializableMap(Map<String, dynamic> data) =>
      FileStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        mimeType: deserializeParam(
          data['mime_type'],
          ParamType.String,
          false,
        ),
        viewUrl: deserializeParam(
          data['view_url'],
          ParamType.String,
          false,
        ),
        downloadUrl: deserializeParam(
          data['download_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FileStruct &&
        name == other.name &&
        id == other.id &&
        mimeType == other.mimeType &&
        viewUrl == other.viewUrl &&
        downloadUrl == other.downloadUrl;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, id, mimeType, viewUrl, downloadUrl]);
}

FileStruct createFileStruct({
  String? name,
  String? id,
  String? mimeType,
  String? viewUrl,
  String? downloadUrl,
}) =>
    FileStruct(
      name: name,
      id: id,
      mimeType: mimeType,
      viewUrl: viewUrl,
      downloadUrl: downloadUrl,
    );
