import 'package:json_annotation/json_annotation.dart';

part 'package_info.g.dart';

///
@JsonSerializable()
class PackageInfo {
  ///
  PackageInfo({required this.name, required this.versions});

  ///
  factory PackageInfo.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoFromJson(json);

  /// The name of the package.
  final String name;

  /// The version list for the package.
  final List<String> versions;

  ///
  Map<String, dynamic> toJson() => _$PackageInfoToJson(this);
}
