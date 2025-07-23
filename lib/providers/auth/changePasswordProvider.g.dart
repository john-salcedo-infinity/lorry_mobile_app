// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changePasswordProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordServiceHash() =>
    r'59a02b54bb9531340d6844e4592081276f58c17a';

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

/// See also [changePasswordService].
@ProviderFor(changePasswordService)
const changePasswordServiceProvider = ChangePasswordServiceFamily();

/// See also [changePasswordService].
class ChangePasswordServiceFamily extends Family<AsyncValue<AuthResponse>> {
  /// See also [changePasswordService].
  const ChangePasswordServiceFamily();

  /// See also [changePasswordService].
  ChangePasswordServiceProvider call(
    String newPassword,
    String confirmPassword,
  ) {
    return ChangePasswordServiceProvider(
      newPassword,
      confirmPassword,
    );
  }

  @override
  ChangePasswordServiceProvider getProviderOverride(
    covariant ChangePasswordServiceProvider provider,
  ) {
    return call(
      provider.newPassword,
      provider.confirmPassword,
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
  String? get name => r'changePasswordServiceProvider';
}

/// See also [changePasswordService].
class ChangePasswordServiceProvider
    extends AutoDisposeFutureProvider<AuthResponse> {
  /// See also [changePasswordService].
  ChangePasswordServiceProvider(
    String newPassword,
    String confirmPassword,
  ) : this._internal(
          (ref) => changePasswordService(
            ref as ChangePasswordServiceRef,
            newPassword,
            confirmPassword,
          ),
          from: changePasswordServiceProvider,
          name: r'changePasswordServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$changePasswordServiceHash,
          dependencies: ChangePasswordServiceFamily._dependencies,
          allTransitiveDependencies:
              ChangePasswordServiceFamily._allTransitiveDependencies,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        );

  ChangePasswordServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.newPassword,
    required this.confirmPassword,
  }) : super.internal();

  final String newPassword;
  final String confirmPassword;

  @override
  Override overrideWith(
    FutureOr<AuthResponse> Function(ChangePasswordServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChangePasswordServiceProvider._internal(
        (ref) => create(ref as ChangePasswordServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AuthResponse> createElement() {
    return _ChangePasswordServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChangePasswordServiceProvider &&
        other.newPassword == newPassword &&
        other.confirmPassword == confirmPassword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, newPassword.hashCode);
    hash = _SystemHash.combine(hash, confirmPassword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChangePasswordServiceRef on AutoDisposeFutureProviderRef<AuthResponse> {
  /// The parameter `newPassword` of this provider.
  String get newPassword;

  /// The parameter `confirmPassword` of this provider.
  String get confirmPassword;
}

class _ChangePasswordServiceProviderElement
    extends AutoDisposeFutureProviderElement<AuthResponse>
    with ChangePasswordServiceRef {
  _ChangePasswordServiceProviderElement(super.provider);

  @override
  String get newPassword =>
      (origin as ChangePasswordServiceProvider).newPassword;
  @override
  String get confirmPassword =>
      (origin as ChangePasswordServiceProvider).confirmPassword;
}

String _$changePasswordFormProviderHash() =>
    r'14ddd11b9569379d4b138a08b73b9c2124fc9947';

/// See also [ChangePasswordFormProvider].
@ProviderFor(ChangePasswordFormProvider)
final changePasswordFormProviderProvider = AutoDisposeNotifierProvider<
    ChangePasswordFormProvider, Map<String, String>>.internal(
  ChangePasswordFormProvider.new,
  name: r'changePasswordFormProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordFormProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePasswordFormProvider = AutoDisposeNotifier<Map<String, String>>;
String _$changePasswordLoadingProviderHash() =>
    r'84496f4ef5718e4d9f5b893f31fd37385419eb05';

/// See also [ChangePasswordLoadingProvider].
@ProviderFor(ChangePasswordLoadingProvider)
final changePasswordLoadingProviderProvider =
    AutoDisposeNotifierProvider<ChangePasswordLoadingProvider, bool>.internal(
  ChangePasswordLoadingProvider.new,
  name: r'changePasswordLoadingProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordLoadingProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePasswordLoadingProvider = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
