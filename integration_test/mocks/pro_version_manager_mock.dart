import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_chips/services/monitization/purchases/models/pro_version_model.dart';
import 'package:pocket_chips/services/monitization/purchases/pro_version_manager.dart';

class MockProVersionManager extends ProVersionManager {
  ProVersionModel? _initialState;
  ProVersionModel? _restoredState;

  MockProVersionManager({
    ProVersionModel? initialState,
    ProVersionModel? restoredState,
  }) {
    _initialState = initialState;
    _restoredState = restoredState;
  }

  Timer? _restoreTimer;

  @override
  FutureOr<ProVersionModel> build() async {
    ref.onDispose(() {
      _restoreTimer?.cancel();
    });

    if (state.value != null) {
      return state.value!;
    }

    if (_initialState != null) {
      return _initialState!;
    }
    return ProVersionModel(
      availableProduct: null,
      isPurchased: false,
      forceDisable: false,
    );
  }

  @override
  Future<void> restorePurchases() async {
    if (_restoredState != null) {
      _restoreTimer = Timer(
        const Duration(seconds: 2),
        () {
          state = AsyncData(_restoredState!);
        },
      );
    }
  }

  void restoreState(ProVersionModel model) {
    state = AsyncData(model);
  }

  @override
  Future<void> handlePurchase(dynamic purchaseDetails) async {}

  @override
  Future<void> buyPro() async {
    if (state.value == null) {
      return;
    }

    state = AsyncData(
      state.value!.copyWith(
        isPurchased: true,
        forceDisable: false,
      ),
    );
  }
}
