#!/bin/bash

## Build TwitterKit.framework - x86_64
xcodebuild \
    -project TwitterKit/TwitterKit.xcodeproj \
    -scheme TwitterKit -configuration Release \
    -sdk "iphonesimulator" \
    HEADER_SEARCH_PATHS="$(pwd)/TwitterCore/iphonesimulator/Headers $(pwd)/TwitterCore/iphonesimulator/PrivateHeaders"  \
    CONFIGURATION_BUILD_DIR=./iphonesimulator \
    clean build

## Build TwitterKit.framework - armv7, arm64
xcodebuild \
    -project TwitterKit/TwitterKit.xcodeproj \
    -scheme TwitterKit -configuration Release \
    -sdk "iphoneos" \
    HEADER_SEARCH_PATHS="$(pwd)/TwitterCore/iphoneos/Headers $(pwd)/TwitterCore/iphoneos/PrivateHeaders"  \
    CONFIGURATION_BUILD_DIR=./iphoneos \
    clean build

## Build TwitterCore.framework - x86_64
xcodebuild \
    -project TwitterCore/TwitterCore.xcodeproj \
    -scheme TwitterCore -configuration Release \
    -sdk "iphonesimulator" \
    CONFIGURATION_BUILD_DIR=./iphonesimulator \
    clean build

## Build TwitterCore.framework - armv7, arm64
xcodebuild \
    -project TwitterCore/TwitterCore.xcodeproj \
    -scheme TwitterCore -configuration Release \
    -sdk "iphoneos" \
    CONFIGURATION_BUILD_DIR=./iphoneos \
    clean build


## Merge into one TwitterKit.framework with x86_64, armv7, arm64
rm -rf iOS
mkdir -p iOS
cp -r TwitterKit/iphoneos/TwitterKit.framework/ iOS/TwitterKit.framework
lipo -create -output iOS/TwitterKit.framework/TwitterKit TwitterKit/iphoneos/TwitterKit.framework/TwitterKit TwitterKit/iphonesimulator/TwitterKit.framework/TwitterKit
lipo -archs iOS/TwitterKit.framework/TwitterKit

## Merge into one TwitterCore.framework with x86_64, armv7, arm64
cp -r TwitterCore/iphoneos/TwitterCore.framework/ iOS/TwitterCore.framework
lipo -create -output iOS/TwitterCore.framework/TwitterCore TwitterCore/iphoneos/TwitterCore.framework/TwitterCore TwitterCore/iphonesimulator/TwitterCore.framework/TwitterCore
lipo -archs iOS/TwitterCore.framework/TwitterCore

## Move TwitterKitResources.bundle to iOS folder
mv iOS/TwitterKit.framework/TwitterKitResources.bundle iOS/

## Zip them into TwitterKit.zip
rm TwitterKit.zip
zip -r TwitterKit.zip iOS/*
rm -rf iOS
