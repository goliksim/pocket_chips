codegen:
	fvm dart run build_runner build --delete-conflicting-outputs
clean:
	fvm flutter clean
clean_deps:
	make clean && fvm flutter pub get
l10n:
	fvm flutter gen-l10n && dart format .
test_run:
	fvm flutter test && fvm flutter test integration_test/initialization_tests.dart && fvm flutter test integration_test/pro_version_tests.dart
patrol_test:
	patrol test --target integration_test/all_test.dart --dart-define=ENABLE_FIREBASE=false
build_test_apk: 
	patrol build android --target integration_test/all_test.dart --dart-define=ENABLE_FIREBASE=false --generate-bundle
firebase_test_lab_android:
	gcloud firebase test android run \
		--type instrumentation \
          --use-orchestrator \
          --app build/app/outputs/flutter-apk/app-debug.apk \
          --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
          --timeout 30m \
          --device model=MediumPhone.arm,version=34,locale=en,orientation=portrait \
          --record-video \
          --environment-variables=clearPackageData=true,IS_TEST_LAB=true \
          --results-dir=test_results \
          --results-history-name=e2e_pocket_chips \
		  --project=pocket-chips \
		  --log-http