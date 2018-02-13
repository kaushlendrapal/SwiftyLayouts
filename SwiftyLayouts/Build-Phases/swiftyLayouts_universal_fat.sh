#!/bin/sh

#  swiftyLayouts_universal_fat.sh
#  SwiftyLayouts
#
#  Created by kaushal on 13/02/18.
#  Copyright © 2018 kaushal. All rights reserved.

#!/bin/bash

# Adapted from http://stackoverflow.com/questions/24039470/xcode-6-ios-creating-a-cocoa-touch-framework-architectures-issues/26691080#26691080
# and https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79

# Create a new aggregate target.
# For the automatically generated scheme, change its build config to "release".
# Ensure this target's "product name" build setting matches the framework's.
# Add a run script with `source "${PROJECT_DIR}/path_to_this_script`

UNIVERSAL_OUTPUT_DIR=${BUILD_DIR}/${CONFIGURATION}-universal
RELEASE_DIR=${PROJECT_DIR}/Products/${CONFIGURATION}-universal

# Remove universal folder and its directory if exist
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
rm -rf "${RELEASE_DIR}"

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUT_DIR}"
mkdir -p "${RELEASE_DIR}"

# Step 1. Build Device and Simulator versions
echo "=== Building for iPhone device ==="
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

echo "=== Building for iPhoneSimulator ==="
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO -arch x86_64 -destination 'platform=iOS Simulator,name=iPhone 8' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUT_DIR}/"

# Step 5. Copy the dSYM structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework.dSYM" "${UNIVERSAL_OUTPUT_DIR}/"

# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUT_DIR}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/"
fi

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "=== Combining executables ==="
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"


# Step 7. Remove existing builds
#rm -rf "${RELEASE_DIR}"

# Step 5. Convenience step to copy the framework to the project's directory
echo "===Copying to project dir ==="
cp -R "${UNIVERSAL_OUTPUT_DIR}/${PROJECT_NAME}.framework" "${RELEASE_DIR}"
cp -R "${UNIVERSAL_OUTPUT_DIR}/${PROJECT_NAME}.framework.dSYM" "${RELEASE_DIR}"

# Step 6. Convenience step to open the project's directory in Finder
open "${RELEASE_DIR}"
