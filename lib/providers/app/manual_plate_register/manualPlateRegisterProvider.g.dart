// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manualPlateRegisterProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMountingByPlateHash() =>
    r'fc5f1f0a1510e3c0f36c3c2f7cc7c75160d493b7';

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

/// See also [getMountingByPlate].
@ProviderFor(getMountingByPlate)
const getMountingByPlateProvider = GetMountingByPlateFamily();

/// See also [getMountingByPlate].
class GetMountingByPlateFamily
    extends Family<AsyncValue<ManualPlateRegisterResponse>> {
  /// See also [getMountingByPlate].
  const GetMountingByPlateFamily();

  /// See also [getMountingByPlate].
  GetMountingByPlateProvider call(
    String licensePlate,
  ) {
    return GetMountingByPlateProvider(
      licensePlate,
    );
  }

  @override
  GetMountingByPlateProvider getProviderOverride(
    covariant GetMountingByPlateProvider provider,
  ) {
    return call(
      provider.licensePlate,
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
  String? get name => r'getMountingByPlateProvider';
}

/// See also [getMountingByPlate].
class GetMountingByPlateProvider
    extends AutoDisposeFutureProvider<ManualPlateRegisterResponse> {
  /// See also [getMountingByPlate].
  GetMountingByPlateProvider(
    String licensePlate,
  ) : this._internal(
          (ref) => getMountingByPlate(
            ref as GetMountingByPlateRef,
            licensePlate,
          ),
          from: getMountingByPlateProvider,
          name: r'getMountingByPlateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMountingByPlateHash,
          dependencies: GetMountingByPlateFamily._dependencies,
          allTransitiveDependencies:
              GetMountingByPlateFamily._allTransitiveDependencies,
          licensePlate: licensePlate,
        );

  GetMountingByPlateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.licensePlate,
  }) : super.internal();

  final String licensePlate;

  @override
  Override overrideWith(
    FutureOr<ManualPlateRegisterResponse> Function(
            GetMountingByPlateRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMountingByPlateProvider._internal(
        (ref) => create(ref as GetMountingByPlateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        licensePlate: licensePlate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ManualPlateRegisterResponse>
      createElement() {
    return _GetMountingByPlateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMountingByPlateProvider &&
        other.licensePlate == licensePlate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, licensePlate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMountingByPlateRef
    on AutoDisposeFutureProviderRef<ManualPlateRegisterResponse> {
  /// The parameter `licensePlate` of this provider.
  String get licensePlate;
}

class _GetMountingByPlateProviderElement
    extends AutoDisposeFutureProviderElement<ManualPlateRegisterResponse>
    with GetMountingByPlateRef {
  _GetMountingByPlateProviderElement(super.provider);

  @override
  String get licensePlate =>
      (origin as GetMountingByPlateProvider).licensePlate;
}

String _$manualPlateRegisterStateHash() =>
    r'e3cd224f89d189e714b45db034d94c213d7d3c8e';

/// See also [ManualPlateRegisterState].
@ProviderFor(ManualPlateRegisterState)
final manualPlateRegisterStateProvider = AutoDisposeNotifierProvider<
    ManualPlateRegisterState, ManualPlateRegisterResponse?>.internal(
  ManualPlateRegisterState.new,
  name: r'manualPlateRegisterStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$manualPlateRegisterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ManualPlateRegisterState
    = AutoDisposeNotifier<ManualPlateRegisterResponse?>;
String _$manualPlateRegisterLoadingHash() =>
    r'40535fb9bd5094ef37d6c200150893e3c460e13d';

/// See also [ManualPlateRegisterLoading].
@ProviderFor(ManualPlateRegisterLoading)
final manualPlateRegisterLoadingProvider =
    AutoDisposeNotifierProvider<ManualPlateRegisterLoading, bool>.internal(
  ManualPlateRegisterLoading.new,
  name: r'manualPlateRegisterLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$manualPlateRegisterLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ManualPlateRegisterLoading = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
