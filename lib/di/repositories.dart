import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/app_repository_impl.dart';
import '../domain/repositories/app_repository.dart';
import 'domain_managers.dart';

final appRepositoryProvider = Provider<AppRepository>(
  (ref) => AppRepositoryImpl(
    localStorage: ref.read(localStorageProvider),
  ),
);
