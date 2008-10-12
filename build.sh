#!/bin/bash

# Release
xcodebuild -project Feeds.xcodeproj/ -target Feeds-iPhone -configuration Release -sdk iphonesimulator2.1
xcodebuild -project Feeds.xcodeproj/ -target Feeds-iPhone -configuration Release -sdk iphoneos2.1
xcodebuild -project Feeds.xcodeproj/ -target Feeds -configuration Release -sdk macosx10.5

# Documentation
xcodebuild -project Feeds.xcodeproj/ -target Documentation -configuration Release -sdk macosx10.5

# Consolidate into a single folder
rm -rf Redist
mkdir Redist
mkdir Redist/Documentation
mkdir Redist/iPhone
mkdir Redist/iPhone/include
mkdir Redist/iPhone/include/Feeds
mkdir Redist/iPhone/lib
mkdir Redist/MacOS

cp LICENSE Redist/

cp build/Release-iphoneos/Feeds/* Redist/iPhone/include/Feeds
cp build/Release-iphoneos/libFeeds-iPhone-iphoneos.a Redist/iPhone/lib/
cp build/Release-iphonesimulator/libFeeds-iPhone-iphonesimulator.a Redist/iPhone/lib/
cp -R build/Release/Feeds.framework Redist/MacOS/

cp -R Documentation/DoxygenDocs.docset/html/org.noxa.Feeds.docset Redist/
cp -R Documentation/html/* Redist/Documentation/
rm -Rf Redist/Documentation/org.noxa.Feeds.docset
