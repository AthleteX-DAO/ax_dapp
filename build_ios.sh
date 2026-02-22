#!/bin/bash
set -e

echo "Cleaning..."
flutter clean
rm -rf ios/Pods ios/Podfile.lock build

echo "Getting dependencies..."
flutter pub get

echo "Installing pods..."
cd ios
rm -rf Pods Podfile.lock
pod install
echo "Stripping -G flags..."
sed -i '' 's/ -G / /g' Pods/Pods.xcodeproj/project.pbxproj
cd ..

echo "Running app..."
flutter run
