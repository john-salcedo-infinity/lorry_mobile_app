// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noveltyProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noveltyServiceHash() => r'bab4cb5a2087533b8db40d47217e810a4f947b2f';

/// See also [noveltyService].
@ProviderFor(noveltyService)
final noveltyServiceProvider =
    AutoDisposeFutureProvider<NoveltyResponse>.internal(
  noveltyService,
  name: r'noveltyServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noveltyServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoveltyServiceRef = AutoDisposeFutureProviderRef<NoveltyResponse>;
String _$noveltliesHash() => r'5e58dca1a585e832c1fe521dc90116a57aae9fa4';

/// See also [Noveltlies].
@ProviderFor(Noveltlies)
final noveltliesProvider =
    AutoDisposeNotifierProvider<Noveltlies, List<NoveltyResponse>>.internal(
  Noveltlies.new,
  name: r'noveltliesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$noveltliesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Noveltlies = AutoDisposeNotifier<List<NoveltyResponse>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
