import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/app_repository_impl.dart';
import '../data/repositories/in_app_purchase_repository_impl.dart';
import '../data/repositories/pro_verion_repository_impl.dart';
import '../data/repositories/purchases_repository_impl.dart';
import '../domain/repositories/app_repository.dart';
import '../domain/repositories/in_app_purchase_repository.dart';
import '../domain/repositories/purchases_repository.dart';
import 'domain_managers.dart';

final appRepositoryProvider = Provider<AppRepository>(
  (ref) => AppRepositoryImpl(
    localStorage: ref.read(localStorageProvider),
    secureStorage: ref.read(secureStorageProvider),
  ),
);

final purchasesRepositoryProvider = Provider<PurchasesRepository>(
  (ref) => PurchasesRepositoryImpl(
    inAppPurchaseRepository: ref.read(inAppPurchaseRepositoryProvider),
  ),
);

final proVersionRepositoryProvider = Provider<PurchasesRepository>(
  (ref) => ProVersionRepository(
    inAppPurchaseRepository: ref.read(inAppPurchaseRepositoryProvider),
  ),
);

final inAppPurchaseRepositoryProvider = Provider<InAppPurchaseRepository>(
  (ref) => InAppPurchaseRepositoryImpl(),
);
