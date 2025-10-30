codegen:
	fvm dart run build_runner build --delete-conflicting-outputs
clean:
	fvm flutter clean
clean_deps:
	make clean && fvm flutter pub get
test_run:
	fvm flutter test
