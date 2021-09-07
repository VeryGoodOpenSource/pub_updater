// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, cast_nullable_to_non_nullable

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
          versions: $checkedConvert('versions',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );
