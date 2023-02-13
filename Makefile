BUILD_DIR = build
DERIVED_DATA = $(BUILD_DIR)/derived_data
DEVICE_BUILD = $(BUILD_DIR)/devices
SIMULATOR_BUILD = $(BUILD_DIR)/simulators

clean:
	rm -rf $(BUILD_DIR)

setup: build_static_library
	rm -rf start/Libs
	mkdir -p start/Libs

	cp -R $(BUILD_DIR)/StaticAnimals.xcframework start/Libs/StaticAnimals.xcframework
	cp -R $(BUILD_DIR)/AnimalFramework.xcframework start/Libs/AnimalFramework.xcframework
	cp -R $(BUILD_DIR)/StaticAnimals.xcframework start/Libs/StaticAnimals.xcframework
	cp -R $(BUILD_DIR)/StaticAnimals.xcframework start/Libs/StaticAnimals.xcframework

	rm -rf final/Libs
	mkdir -p final/Libs

	cp -R $(BUILD_DIR)/StaticAnimals.xcframework final/Libs/StaticAnimals.xcframework
	cp -R $(BUILD_DIR)/AnimalFramework.xcframework final/Libs/AnimalFramework.xcframework
	cp -R $(BUILD_DIR)/StaticAnimals.xcframework final/Libs/StaticAnimals.xcframework
	cp -R $(BUILD_DIR)/StaticAnimals.xcframework final/Libs/StaticAnimals.xcframework

build_static_library: clean
	mkdir -p $(SIMULATOR_BUILD)

	@echo "Make Static Library"

	xcodebuild build \
	-project Animals/StaticAnimals.xcodeproj \
	-scheme StaticAnimals \
	-derivedDataPath $(DERIVED_DATA) \
	-sdk iphonesimulator

	xcodebuild build \
	-project Animals/StaticAnimals.xcodeproj \
	-scheme StaticAnimals \
	-derivedDataPath $(DERIVED_DATA) \
	-sdk iphoneos

	cp -r ${DERIVED_DATA}/Build/Products/Debug-iphonesimulator/ $(SIMULATOR_BUILD)
	cp -r ${DERIVED_DATA}/Build/Products/Debug-iphoneos/ $(DEVICE_BUILD)

	xcodebuild -create-xcframework \
    -library $(SIMULATOR_BUILD)/libStaticAnimals.a \
	-library $(DEVICE_BUILD)/libStaticAnimals.a \
    -output $(BUILD_DIR)/StaticAnimals.xcframework

	@echo "Make Dynamic xcframework"

	xcodebuild archive \
	-project ./Animals/StaticAnimals.xcodeproj \
	-scheme AnimalFramework \
	-destination "generic/platform=iOS" \
	-archivePath ./output/AnimalFramework-iOS \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES

	xcodebuild archive \
	-project ./Animals/StaticAnimals.xcodeproj \
	-scheme AnimalFramework \
	-destination "generic/platform=iOS Simulator" \
	-archivePath ./output/AnimalFramework-Sim \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES

	xcodebuild -create-xcframework \
	-framework ./output/AnimalFramework-Sim.xcarchive/Products/Library/Frameworks/AnimalFramework.framework \
	-framework ./output/AnimalFramework-iOS.xcarchive/Products/Library/Frameworks/AnimalFramework.framework \
	-output $(BUILD_DIR)/AnimalFramework.xcframework
