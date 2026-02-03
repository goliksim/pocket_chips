codegen:
	fvm dart run build_runner build --delete-conflicting-outputs
clean:
	fvm flutter clean
clean_deps:
	make clean && fvm flutter pub get
test_run:
	fvm flutter test && fvm flutter test integration_test/initialization_tests.dart && fvm flutter test integration_test/pro_version_tests.dart
l10n:
	fvm flutter gen-l10n
