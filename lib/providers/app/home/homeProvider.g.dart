// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homeProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inspectionAllServiceHash() =>
    r'71fdb8fdd9464d953ad3043811b598c0398fe167';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [inspectionAllService].
@ProviderFor(inspectionAllService)
const inspectionAllServiceProvider = InspectionAllServiceFamily();

/// See also [inspectionAllService].
class InspectionAllServiceFamily extends Family<AsyncValue<InspectionHistory>> {
  /// See also [inspectionAllService].
  const InspectionAllServiceFamily();

  /// See also [inspectionAllService].
  InspectionAllServiceProvider call(
    Map<String, String>? queryParams,
  ) {
    return InspectionAllServiceProvider(
      queryParams,
    );
  }

  @override
  InspectionAllServiceProvider getProviderOverride(
    covariant InspectionAllServiceProvider provider,
  ) {
    return call(
      provider.queryParams,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'inspectionAllServiceProvider';
}

/// See also [inspectionAllService].
class InspectionAllServiceProvider
    extends AutoDisposeFutureProvider<InspectionHistory> {
  /// See also [inspectionAllService].
  InspectionAllServiceProvider(
    Map<String, String>? queryParams,
  ) : this._internal(
          (ref) => inspectionAllService(
            ref as InspectionAllServiceRef,
            queryParams,
          ),
          from: inspectionAllServiceProvider,
          name: r'inspectionAllServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inspectionAllServiceHash,
          dependencies: InspectionAllServiceFamily._dependencies,
          allTransitiveDependencies:
              InspectionAllServiceFamily._allTransitiveDependencies,
          queryParams: queryParams,
        );

  InspectionAllServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queryParams,
  }) : super.internal();

  final Map<String, String>? queryParams;

  @override
  Override overrideWith(
    FutureOr<InspectionHistory> Function(InspectionAllServiceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InspectionAllServiceProvider._internal(
        (ref) => create(ref as InspectionAllServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queryParams: queryParams,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InspectionHistory> createElement() {
    return _InspectionAllServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InspectionAllServiceProvider &&
        other.queryParams == queryParams;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queryParams.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InspectionAllServiceRef
    on AutoDisposeFutureProviderRef<InspectionHistory> {
  /// The parameter `queryParams` of this provider.
  Map<String, String>? get queryParams;
}

class _InspectionAllServiceProviderElement
    extends AutoDisposeFutureProviderElement<InspectionHistory>
    with InspectionAllServiceRef {
  _InspectionAllServiceProviderElement(super.provider);

  @override
  Map<String, String>? get queryParams =>
      (origin as InspectionAllServiceProvider).queryParams;
}

String _$inspectionsHash() => r'c7c16c19bfce890b48dc6dd7852d49b6d8aa78b2';

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
    r'765f2c3c64659ce2187f204e115180497be5d474';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
