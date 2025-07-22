// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loginProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginServiceProviderHash() =>
    r'6bdf65eb6fcf84143ba7a0b61e39a108a4488fd4';

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

/// See also [LoginServiceProvider].
@ProviderFor(LoginServiceProvider)
const loginServiceProviderProvider = LoginServiceProviderFamily();

/// See also [LoginServiceProvider].
class LoginServiceProviderFamily extends Family<AsyncValue<AuthResponse>> {
  /// See also [LoginServiceProvider].
  const LoginServiceProviderFamily();

  /// See also [LoginServiceProvider].
  LoginServiceProviderProvider call(
    String email,
    String password,
  ) {
    return LoginServiceProviderProvider(
      email,
      password,
    );
  }

  @override
  LoginServiceProviderProvider getProviderOverride(
    covariant LoginServiceProviderProvider provider,
  ) {
    return call(
      provider.email,
      provider.password,
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
  String? get name => r'loginServiceProviderProvider';
}

/// See also [LoginServiceProvider].
class LoginServiceProviderProvider extends FutureProvider<AuthResponse> {
  /// See also [LoginServiceProvider].
  LoginServiceProviderProvider(
    String email,
    String password,
  ) : this._internal(
          (ref) => LoginServiceProvider(
            ref as LoginServiceProviderRef,
            email,
            password,
          ),
          from: loginServiceProviderProvider,
          name: r'loginServiceProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginServiceProviderHash,
          dependencies: LoginServiceProviderFamily._dependencies,
          allTransitiveDependencies:
              LoginServiceProviderFamily._allTransitiveDependencies,
          email: email,
          password: password,
        );

  LoginServiceProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(
    FutureOr<AuthResponse> Function(LoginServiceProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoginServiceProviderProvider._internal(
        (ref) => create(ref as LoginServiceProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  FutureProviderElement<AuthResponse> createElement() {
    return _LoginServiceProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginServiceProviderProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoginServiceProviderRef on FutureProviderRef<AuthResponse> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _LoginServiceProviderProviderElement
    extends FutureProviderElement<AuthResponse> with LoginServiceProviderRef {
  _LoginServiceProviderProviderElement(super.provider);

  @override
  String get email => (origin as LoginServiceProviderProvider).email;
  @override
  String get password => (origin as LoginServiceProviderProvider).password;
}

String _$loginFormProviderHash() => r'c0991eef9c9991be0a262177e2ce24821de2f5f5';

/// See also [LoginFormProvider].
@ProviderFor(LoginFormProvider)
final loginFormProviderProvider = AutoDisposeNotifierProvider<LoginFormProvider,
    Map<String, String>>.internal(
  LoginFormProvider.new,
  name: r'loginFormProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginFormProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoginFormProvider = AutoDisposeNotifier<Map<String, String>>;
String _$loadingProviderHash() => r'e349aae92ef3b504ef509256e145297170c50614';

/// See also [LoadingProvider].
@ProviderFor(LoadingProvider)
final loadingProviderProvider =
    AutoDisposeNotifierProvider<LoadingProvider, bool>.internal(
  LoadingProvider.new,
  name: r'loadingProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadingProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoadingProvider = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
