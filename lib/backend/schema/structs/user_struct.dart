// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    int? id,
    int? createdAt,
    String? name,
    int? dateJoined,
    bool? active,
    String? noic,
    String? email,
    String? nickname,
    String? gender,
    String? role,
    String? branch,
    String? dept,
    String? access,
    String? phone,
    String? address,
    String? status,
    List<int>? accountAccess,
    int? companyInfoId,
    int? accountsId,
    List<int>? superiors,
    String? referralCode,
    LeaveStruct? leave,
    ProfilePicStruct? profilePic,
    FullLeaveStruct? fullLeave,
    BalanceLeaveStruct? balanceLeave,
    String? subordinates,
    List<String>? accessList,
  })  : _id = id,
        _createdAt = createdAt,
        _name = name,
        _dateJoined = dateJoined,
        _active = active,
        _noic = noic,
        _email = email,
        _nickname = nickname,
        _gender = gender,
        _role = role,
        _branch = branch,
        _dept = dept,
        _access = access,
        _phone = phone,
        _address = address,
        _status = status,
        _accountAccess = accountAccess,
        _companyInfoId = companyInfoId,
        _accountsId = accountsId,
        _superiors = superiors,
        _referralCode = referralCode,
        _leave = leave,
        _profilePic = profilePic,
        _fullLeave = fullLeave,
        _balanceLeave = balanceLeave,
        _subordinates = subordinates,
        _accessList = accessList;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
  int? _createdAt;
  int get createdAt => _createdAt ?? 0;
  set createdAt(int? val) => _createdAt = val;

  void incrementCreatedAt(int amount) => createdAt = createdAt + amount;

  bool hasCreatedAt() => _createdAt != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "dateJoined" field.
  int? _dateJoined;
  int get dateJoined => _dateJoined ?? 0;
  set dateJoined(int? val) => _dateJoined = val;

  void incrementDateJoined(int amount) => dateJoined = dateJoined + amount;

  bool hasDateJoined() => _dateJoined != null;

  // "active" field.
  bool? _active;
  bool get active => _active ?? false;
  set active(bool? val) => _active = val;

  bool hasActive() => _active != null;

  // "noic" field.
  String? _noic;
  String get noic => _noic ?? '';
  set noic(String? val) => _noic = val;

  bool hasNoic() => _noic != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "nickname" field.
  String? _nickname;
  String get nickname => _nickname ?? '';
  set nickname(String? val) => _nickname = val;

  bool hasNickname() => _nickname != null;

  // "Gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  set gender(String? val) => _gender = val;

  bool hasGender() => _gender != null;

  // "Role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "Branch" field.
  String? _branch;
  String get branch => _branch ?? '';
  set branch(String? val) => _branch = val;

  bool hasBranch() => _branch != null;

  // "dept" field.
  String? _dept;
  String get dept => _dept ?? '';
  set dept(String? val) => _dept = val;

  bool hasDept() => _dept != null;

  // "Access" field.
  String? _access;
  String get access => _access ?? '';
  set access(String? val) => _access = val;

  bool hasAccess() => _access != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "Status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "account_access" field.
  List<int>? _accountAccess;
  List<int> get accountAccess => _accountAccess ?? const [];
  set accountAccess(List<int>? val) => _accountAccess = val;

  void updateAccountAccess(Function(List<int>) updateFn) {
    updateFn(_accountAccess ??= []);
  }

  bool hasAccountAccess() => _accountAccess != null;

  // "company_info_id" field.
  int? _companyInfoId;
  int get companyInfoId => _companyInfoId ?? 0;
  set companyInfoId(int? val) => _companyInfoId = val;

  void incrementCompanyInfoId(int amount) =>
      companyInfoId = companyInfoId + amount;

  bool hasCompanyInfoId() => _companyInfoId != null;

  // "accounts_id" field.
  int? _accountsId;
  int get accountsId => _accountsId ?? 0;
  set accountsId(int? val) => _accountsId = val;

  void incrementAccountsId(int amount) => accountsId = accountsId + amount;

  bool hasAccountsId() => _accountsId != null;

  // "superiors" field.
  List<int>? _superiors;
  List<int> get superiors => _superiors ?? const [];
  set superiors(List<int>? val) => _superiors = val;

  void updateSuperiors(Function(List<int>) updateFn) {
    updateFn(_superiors ??= []);
  }

  bool hasSuperiors() => _superiors != null;

  // "Referral_Code" field.
  String? _referralCode;
  String get referralCode => _referralCode ?? '';
  set referralCode(String? val) => _referralCode = val;

  bool hasReferralCode() => _referralCode != null;

  // "leave" field.
  LeaveStruct? _leave;
  LeaveStruct get leave => _leave ?? LeaveStruct();
  set leave(LeaveStruct? val) => _leave = val;

  void updateLeave(Function(LeaveStruct) updateFn) {
    updateFn(_leave ??= LeaveStruct());
  }

  bool hasLeave() => _leave != null;

  // "profile_pic" field.
  ProfilePicStruct? _profilePic;
  ProfilePicStruct get profilePic => _profilePic ?? ProfilePicStruct();
  set profilePic(ProfilePicStruct? val) => _profilePic = val;

  void updateProfilePic(Function(ProfilePicStruct) updateFn) {
    updateFn(_profilePic ??= ProfilePicStruct());
  }

  bool hasProfilePic() => _profilePic != null;

  // "full_leave" field.
  FullLeaveStruct? _fullLeave;
  FullLeaveStruct get fullLeave => _fullLeave ?? FullLeaveStruct();
  set fullLeave(FullLeaveStruct? val) => _fullLeave = val;

  void updateFullLeave(Function(FullLeaveStruct) updateFn) {
    updateFn(_fullLeave ??= FullLeaveStruct());
  }

  bool hasFullLeave() => _fullLeave != null;

  // "balance_leave" field.
  BalanceLeaveStruct? _balanceLeave;
  BalanceLeaveStruct get balanceLeave => _balanceLeave ?? BalanceLeaveStruct();
  set balanceLeave(BalanceLeaveStruct? val) => _balanceLeave = val;

  void updateBalanceLeave(Function(BalanceLeaveStruct) updateFn) {
    updateFn(_balanceLeave ??= BalanceLeaveStruct());
  }

  bool hasBalanceLeave() => _balanceLeave != null;

  // "subordinates" field.
  String? _subordinates;
  String get subordinates => _subordinates ?? '';
  set subordinates(String? val) => _subordinates = val;

  bool hasSubordinates() => _subordinates != null;

  // "access_list" field.
  List<String>? _accessList;
  List<String> get accessList => _accessList ?? const [];
  set accessList(List<String>? val) => _accessList = val;

  void updateAccessList(Function(List<String>) updateFn) {
    updateFn(_accessList ??= []);
  }

  bool hasAccessList() => _accessList != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        name: data['name'] as String?,
        dateJoined: castToType<int>(data['dateJoined']),
        active: data['active'] as bool?,
        noic: data['noic'] as String?,
        email: data['email'] as String?,
        nickname: data['nickname'] as String?,
        gender: data['Gender'] as String?,
        role: data['Role'] as String?,
        branch: data['Branch'] as String?,
        dept: data['dept'] as String?,
        access: data['Access'] as String?,
        phone: data['phone'] as String?,
        address: data['address'] as String?,
        status: data['Status'] as String?,
        accountAccess: getDataList(data['account_access']),
        companyInfoId: castToType<int>(data['company_info_id']),
        accountsId: castToType<int>(data['accounts_id']),
        superiors: getDataList(data['superiors']),
        referralCode: data['Referral_Code'] as String?,
        leave: data['leave'] is LeaveStruct
            ? data['leave']
            : LeaveStruct.maybeFromMap(data['leave']),
        profilePic: data['profile_pic'] is ProfilePicStruct
            ? data['profile_pic']
            : ProfilePicStruct.maybeFromMap(data['profile_pic']),
        fullLeave: data['full_leave'] is FullLeaveStruct
            ? data['full_leave']
            : FullLeaveStruct.maybeFromMap(data['full_leave']),
        balanceLeave: data['balance_leave'] is BalanceLeaveStruct
            ? data['balance_leave']
            : BalanceLeaveStruct.maybeFromMap(data['balance_leave']),
        subordinates: data['subordinates'] as String?,
        accessList: getDataList(data['access_list']),
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'name': _name,
        'dateJoined': _dateJoined,
        'active': _active,
        'noic': _noic,
        'email': _email,
        'nickname': _nickname,
        'Gender': _gender,
        'Role': _role,
        'Branch': _branch,
        'dept': _dept,
        'Access': _access,
        'phone': _phone,
        'address': _address,
        'Status': _status,
        'account_access': _accountAccess,
        'company_info_id': _companyInfoId,
        'accounts_id': _accountsId,
        'superiors': _superiors,
        'Referral_Code': _referralCode,
        'leave': _leave?.toMap(),
        'profile_pic': _profilePic?.toMap(),
        'full_leave': _fullLeave?.toMap(),
        'balance_leave': _balanceLeave?.toMap(),
        'subordinates': _subordinates,
        'access_list': _accessList,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'dateJoined': serializeParam(
          _dateJoined,
          ParamType.int,
        ),
        'active': serializeParam(
          _active,
          ParamType.bool,
        ),
        'noic': serializeParam(
          _noic,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'nickname': serializeParam(
          _nickname,
          ParamType.String,
        ),
        'Gender': serializeParam(
          _gender,
          ParamType.String,
        ),
        'Role': serializeParam(
          _role,
          ParamType.String,
        ),
        'Branch': serializeParam(
          _branch,
          ParamType.String,
        ),
        'dept': serializeParam(
          _dept,
          ParamType.String,
        ),
        'Access': serializeParam(
          _access,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'Status': serializeParam(
          _status,
          ParamType.String,
        ),
        'account_access': serializeParam(
          _accountAccess,
          ParamType.int,
          isList: true,
        ),
        'company_info_id': serializeParam(
          _companyInfoId,
          ParamType.int,
        ),
        'accounts_id': serializeParam(
          _accountsId,
          ParamType.int,
        ),
        'superiors': serializeParam(
          _superiors,
          ParamType.int,
          isList: true,
        ),
        'Referral_Code': serializeParam(
          _referralCode,
          ParamType.String,
        ),
        'leave': serializeParam(
          _leave,
          ParamType.DataStruct,
        ),
        'profile_pic': serializeParam(
          _profilePic,
          ParamType.DataStruct,
        ),
        'full_leave': serializeParam(
          _fullLeave,
          ParamType.DataStruct,
        ),
        'balance_leave': serializeParam(
          _balanceLeave,
          ParamType.DataStruct,
        ),
        'subordinates': serializeParam(
          _subordinates,
          ParamType.String,
        ),
        'access_list': serializeParam(
          _accessList,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        dateJoined: deserializeParam(
          data['dateJoined'],
          ParamType.int,
          false,
        ),
        active: deserializeParam(
          data['active'],
          ParamType.bool,
          false,
        ),
        noic: deserializeParam(
          data['noic'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        nickname: deserializeParam(
          data['nickname'],
          ParamType.String,
          false,
        ),
        gender: deserializeParam(
          data['Gender'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['Role'],
          ParamType.String,
          false,
        ),
        branch: deserializeParam(
          data['Branch'],
          ParamType.String,
          false,
        ),
        dept: deserializeParam(
          data['dept'],
          ParamType.String,
          false,
        ),
        access: deserializeParam(
          data['Access'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['Status'],
          ParamType.String,
          false,
        ),
        accountAccess: deserializeParam<int>(
          data['account_access'],
          ParamType.int,
          true,
        ),
        companyInfoId: deserializeParam(
          data['company_info_id'],
          ParamType.int,
          false,
        ),
        accountsId: deserializeParam(
          data['accounts_id'],
          ParamType.int,
          false,
        ),
        superiors: deserializeParam<int>(
          data['superiors'],
          ParamType.int,
          true,
        ),
        referralCode: deserializeParam(
          data['Referral_Code'],
          ParamType.String,
          false,
        ),
        leave: deserializeStructParam(
          data['leave'],
          ParamType.DataStruct,
          false,
          structBuilder: LeaveStruct.fromSerializableMap,
        ),
        profilePic: deserializeStructParam(
          data['profile_pic'],
          ParamType.DataStruct,
          false,
          structBuilder: ProfilePicStruct.fromSerializableMap,
        ),
        fullLeave: deserializeStructParam(
          data['full_leave'],
          ParamType.DataStruct,
          false,
          structBuilder: FullLeaveStruct.fromSerializableMap,
        ),
        balanceLeave: deserializeStructParam(
          data['balance_leave'],
          ParamType.DataStruct,
          false,
          structBuilder: BalanceLeaveStruct.fromSerializableMap,
        ),
        subordinates: deserializeParam(
          data['subordinates'],
          ParamType.String,
          false,
        ),
        accessList: deserializeParam<String>(
          data['access_list'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UserStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        name == other.name &&
        dateJoined == other.dateJoined &&
        active == other.active &&
        noic == other.noic &&
        email == other.email &&
        nickname == other.nickname &&
        gender == other.gender &&
        role == other.role &&
        branch == other.branch &&
        dept == other.dept &&
        access == other.access &&
        phone == other.phone &&
        address == other.address &&
        status == other.status &&
        listEquality.equals(accountAccess, other.accountAccess) &&
        companyInfoId == other.companyInfoId &&
        accountsId == other.accountsId &&
        listEquality.equals(superiors, other.superiors) &&
        referralCode == other.referralCode &&
        leave == other.leave &&
        profilePic == other.profilePic &&
        fullLeave == other.fullLeave &&
        balanceLeave == other.balanceLeave &&
        subordinates == other.subordinates &&
        listEquality.equals(accessList, other.accessList);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        name,
        dateJoined,
        active,
        noic,
        email,
        nickname,
        gender,
        role,
        branch,
        dept,
        access,
        phone,
        address,
        status,
        accountAccess,
        companyInfoId,
        accountsId,
        superiors,
        referralCode,
        leave,
        profilePic,
        fullLeave,
        balanceLeave,
        subordinates,
        accessList
      ]);
}

UserStruct createUserStruct({
  int? id,
  int? createdAt,
  String? name,
  int? dateJoined,
  bool? active,
  String? noic,
  String? email,
  String? nickname,
  String? gender,
  String? role,
  String? branch,
  String? dept,
  String? access,
  String? phone,
  String? address,
  String? status,
  int? companyInfoId,
  int? accountsId,
  String? referralCode,
  LeaveStruct? leave,
  ProfilePicStruct? profilePic,
  FullLeaveStruct? fullLeave,
  BalanceLeaveStruct? balanceLeave,
  String? subordinates,
}) =>
    UserStruct(
      id: id,
      createdAt: createdAt,
      name: name,
      dateJoined: dateJoined,
      active: active,
      noic: noic,
      email: email,
      nickname: nickname,
      gender: gender,
      role: role,
      branch: branch,
      dept: dept,
      access: access,
      phone: phone,
      address: address,
      status: status,
      companyInfoId: companyInfoId,
      accountsId: accountsId,
      referralCode: referralCode,
      leave: leave ?? LeaveStruct(),
      profilePic: profilePic ?? ProfilePicStruct(),
      fullLeave: fullLeave ?? FullLeaveStruct(),
      balanceLeave: balanceLeave ?? BalanceLeaveStruct(),
      subordinates: subordinates,
    );
