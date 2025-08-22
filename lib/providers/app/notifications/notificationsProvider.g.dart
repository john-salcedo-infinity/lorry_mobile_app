// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationsProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'3741b26eb8630a1cd8048503dcfe53731a803279';

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

/// See also [notificationService].
@ProviderFor(notificationService)
const notificationServiceProvider = NotificationServiceFamily();

/// See also [notificationService].
class NotificationServiceFamily
    extends Family<AsyncValue<NotificationResponse>> {
  /// See also [notificationService].
  const NotificationServiceFamily();

  /// See also [notificationService].
  NotificationServiceProvider call(
    Map<String, String>? queryParams,
  ) {
    return NotificationServiceProvider(
      queryParams,
    );
  }

  @override
  NotificationServiceProvider getProviderOverride(
    covariant NotificationServiceProvider provider,
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
  String? get name => r'notificationServiceProvider';
}

/// See also [notificationService].
class NotificationServiceProvider
    extends AutoDisposeFutureProvider<NotificationResponse> {
  /// See also [notificationService].
  NotificationServiceProvider(
    Map<String, String>? queryParams,
  ) : this._internal(
          (ref) => notificationService(
            ref as NotificationServiceRef,
            queryParams,
          ),
          from: notificationServiceProvider,
          name: r'notificationServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationServiceHash,
          dependencies: NotificationServiceFamily._dependencies,
          allTransitiveDependencies:
              NotificationServiceFamily._allTransitiveDependencies,
          queryParams: queryParams,
        );

  NotificationServiceProvider._internal(
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
    FutureOr<NotificationResponse> Function(NotificationServiceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationServiceProvider._internal(
        (ref) => create(ref as NotificationServiceRef),
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
  AutoDisposeFutureProviderElement<NotificationResponse> createElement() {
    return _NotificationServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationServiceProvider &&
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
mixin NotificationServiceRef
    on AutoDisposeFutureProviderRef<NotificationResponse> {
  /// The parameter `queryParams` of this provider.
  Map<String, String>? get queryParams;
}

class _NotificationServiceProviderElement
    extends AutoDisposeFutureProviderElement<NotificationResponse>
    with NotificationServiceRef {
  _NotificationServiceProviderElement(super.provider);

  @override
  Map<String, String>? get queryParams =>
      (origin as NotificationServiceProvider).queryParams;
}

String _$notificationsHash() => r'51c26795ce5cd32868b62ee5f1d9603de636ed0b';

/// See also [Notifications].
@ProviderFor(Notifications)
final notificationsProvider =
    AutoDisposeNotifierProvider<Notifications, List<Notification>>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications = AutoDisposeNotifier<List<Notification>>;
String _$loadingNotificationsHash() =>
    r'6ca7f3999c3c9f6f2caefd88990b36cfac447c05';

/// See also [LoadingNotifications].
@ProviderFor(LoadingNotifications)
final loadingNotificationsProvider =
    AutoDisposeNotifierProvider<LoadingNotifications, bool>.internal(
  LoadingNotifications.new,
  name: r'loadingNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadingNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoadingNotifications = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
