import 'package:json_annotation/json_annotation.dart';

part 'package_info.g.dart';

/// Class representing package information from pub.dev
@JsonSerializable()
class PackageInfo {
  /// Constructor for a [PackageInfo] object.
  /// Requires a name and list of versions.
  const PackageInfo({required this.name, required this.latest});

  /// Constructor of PackageInfo object from JSON.
  factory PackageInfo.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoFromJson(json);

  /// The name of the package.
  final String name;

  /// The latest version of the package.
  @LatestVersionConverter()
  final String latest;
}

/// {@template latest_version_converter}
/// A [JsonConverter] that handles (de)serializing the latest package version.
/// {@endtemplate}
class LatestVersionConverter
    implements JsonConverter<String, Map<String, dynamic>> {
  /// {@macro latest_version_converter}
  const LatestVersionConverter();

  @override
  String fromJson(Map<String, dynamic> json) => json['version'] as String;

  @override
  Map<String, dynamic> toJson(String object) {
    return <String, dynamic>{'version': object};
  }
}
