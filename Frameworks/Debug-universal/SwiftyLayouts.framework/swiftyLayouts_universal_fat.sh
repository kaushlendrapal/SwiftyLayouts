#!/bin/sh

#  swiftyLayouts_universal_fat.sh
#  SwiftyLayouts
#
#  Created by kaushal on 13/02/18.
#  Copyright © 2018 kaushal. All rights reserved.

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

#RELEASE_DIR=${PROJECT_DIR}/Products/${CONFIGURATION}-universal
RELEASE_DIR=${PROJECT_DIR}/../Frameworks/${CONFIGURATION}-universal

# clear the old cache i universal framework
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${RELEASE_DIR}"

# Step 1. Build Device and Simulator versions
echo "=== Building for iPhone device ==="
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

echo "=== Building for iPhoneSimulator ==="
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO -arch x86_64 -destination 'platform=iOS Simulator,name=iPhone 8' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

echo "=== coping iPhone framework to universal ==="
# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
# Step 3. Copy the dSYM structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework.dSYM" "${UNIVERSAL_OUTPUTFOLDER}/"

echo "=== coping swift module to universal ==="
# Step 4. Copy Swift modules (from iphonesimulator build) to the copied framework directory
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"

# Step 5. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "=== Combining executables ==="
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

rm -rf "${RELEASE_DIR}/${PROJECT_NAME}.framework"

# Step 6. Convenience step to copy the framework to the project's directory
echo "===Copying to project dir ==="
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${RELEASE_DIR}"
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework.dSYM" "${RELEASE_DIR}"

# Step 7. Convenience step to open the project's directory in Finder
open "${RELEASE_DIR}"
