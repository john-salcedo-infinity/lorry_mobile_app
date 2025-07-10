// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homeProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inspectionAllServiceHash() =>
    r'a73bd9d7ca57a728d313bd063da9a3730b0536e4';

/// See also [inspectionAllService].
@ProviderFor(inspectionAllService)
final inspectionAllServiceProvider = FutureProvider<InspectionHistory>.internal(
  inspectionAllService,
  name: r'inspectionAllServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inspectionAllServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InspectionAllServiceRef = FutureProviderRef<InspectionHistory>;
String _$inspectionsHash() => r'0ca979fed9f4978b6dbca3c3326ce4d5474c1b6e';

/// See also [inspections].
@ProviderFor(inspections)
final inspectionsProvider =
    AutoDisposeNotifierProvider<inspections, List<HistoricalResult>>.internal(
  inspections.new,
  name: r'inspectionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inspectionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$inspections = AutoDisposeNotifier<List<HistoricalResult>>;
String _$loadinginspectionsHash() =>
    r'1556fbaab4382b689aebe21aeb97963f0e03b137';

/// See also [Loadinginspections].
@ProviderFor(Loadinginspections)
final loadinginspectionsProvider =
    AutoDisposeNotifierProvider<Loadinginspections, bool>.internal(
  Loadinginspections.new,
  name: r'loadinginspectionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadinginspectionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Loadinginspections = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
