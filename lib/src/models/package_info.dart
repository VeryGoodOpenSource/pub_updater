import 'package:json_annotation/json_annotation.dart';

part 'package_info.g.dart';

/// Class representing package information from pub.dev
@JsonSerializable()
class PackageInfo {
  /// Constructor for a [PackageInfo] object.
  /// Requires a name and list of versions.
  PackageInfo({required this.name, required this.versions});

  /// Constructor of PackageInfo object from JSON.
  factory PackageInfo.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoFromJson(json);

  /// The name of the package.
  final String name;

  /// The version list for the package.
  final List<String> versions;
}
