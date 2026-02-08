// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ImageStruct extends BaseStruct {
  ImageStruct({
    String? access,
    String? path,
    String? name,
    String? type,
    double? size,
    String? mime,
    MetaStruct? meta,
    String? url,
  })  : _access = access,
        _path = path,
        _name = name,
        _type = type,
        _size = size,
        _mime = mime,
        _meta = meta,
        _url = url;

  // "access" field.
  String? _access;
  String get access => _access ?? '';
  set access(String? val) => _access = val;

  bool hasAccess() => _access != null;

  // "path" field.
  String? _path;
  String get path => _path ?? '';
  set path(String? val) => _path = val;

  bool hasPath() => _path != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "size" field.
  double? _size;
  double get size => _size ?? 0.0;
  set size(double? val) => _size = val;

  void incrementSize(double amount) => size = size + amount;

  bool hasSize() => _size != null;

  // "mime" field.
  String? _mime;
  String get mime => _mime ?? '';
  set mime(String? val) => _mime = val;

  bool hasMime() => _mime != null;

  // "meta" field.
  MetaStruct? _meta;
  MetaStruct get meta => _meta ?? MetaStruct();
  set meta(MetaStruct? val) => _meta = val;

  void updateMeta(Function(MetaStruct) updateFn) {
    updateFn(_meta ??= MetaStruct());
  }

  bool hasMeta() => _meta != null;

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

  static ImageStruct fromMap(Map<String, dynamic> data) => ImageStruct(
        access: data['access'] as String?,
        path: data['path'] as String?,
        name: data['name'] as String?,
        type: data['type'] as String?,
        size: castToType<double>(data['size']),
        mime: data['mime'] as String?,
        meta: data['meta'] is MetaStruct
            ? data['meta']
            : MetaStruct.maybeFromMap(data['meta']),
        url: data['url'] as String?,
      );

  static ImageStruct? maybeFromMap(dynamic data) =>
      data is Map ? ImageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'access': _access,
        'path': _path,
        'name': _name,
        'type': _type,
        'size': _size,
        'mime': _mime,
        'meta': _meta?.toMap(),
        'url': _url,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'access': serializeParam(
          _access,
          ParamType.String,
        ),
        'path': serializeParam(
          _path,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'size': serializeParam(
          _size,
          ParamType.double,
        ),
        'mime': serializeParam(
          _mime,
          ParamType.String,
        ),
        'meta': serializeParam(
          _meta,
          ParamType.DataStruct,
        ),
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
      }.withoutNulls;

  static ImageStruct fromSerializableMap(Map<String, dynamic> data) =>
      ImageStruct(
        access: deserializeParam(
          data['access'],
          ParamType.String,
          false,
        ),
        path: deserializeParam(
          data['path'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        size: deserializeParam(
          data['size'],
          ParamType.double,
          false,
        ),
        mime: deserializeParam(
          data['mime'],
          ParamType.String,
          false,
        ),
        meta: deserializeStructParam(
          data['meta'],
          ParamType.DataStruct,
          false,
          structBuilder: MetaStruct.fromSerializableMap,
        ),
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ImageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ImageStruct &&
        access == other.access &&
        path == other.path &&
        name == other.name &&
        type == other.type &&
        size == other.size &&
        mime == other.mime &&
        meta == other.meta &&
        url == other.url;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([access, path, name, type, size, mime, meta, url]);
}

ImageStruct createImageStruct({
  String? access,
  String? path,
  String? name,
  String? type,
  double? size,
  String? mime,
  MetaStruct? meta,
  String? url,
}) =>
    ImageStruct(
      access: access,
      path: path,
      name: name,
      type: type,
      size: size,
      mime: mime,
      meta: meta ?? MetaStruct(),
      url: url,
    );
