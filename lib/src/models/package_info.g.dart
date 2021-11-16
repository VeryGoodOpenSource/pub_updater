// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, cast_nullable_to_non_nullable, require_trailing_commas, lines_longer_than_80_chars

part of 'package_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageInfo _$PackageInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PackageInfo',
      json,
      ($checkedConvert) {
        final val = PackageInfo(
          name: $checkedConvert('name', (v) => v as String),
          latest: $checkedConvert(
              'latest',
              (v) => const LatestVersionConverter()
                  .fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );
