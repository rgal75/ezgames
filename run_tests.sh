#!/bin/bash

SCHEME='EZGames'
DESTINATION='platform=iOS Simulator,OS=26.0,name=iPhone 17'

if grep -R -n --include='*Tests.swift' -E '^\s*// (Arrange|Act|Assert|Given|When|Then)\b' . ; then
  echo "Error: Forbidden test comments detected. Remove these comments from tests."
  exit 1
fi

set -o pipefail && xcodebuild test -scheme $SCHEME -workspace EZGames.xcworkspace -sdk iphonesimulator -destination "$DESTINATION" -disableAutomaticPackageResolution CODE_SIGNING_ALLOWED='NO' | xcbeautify
# tuist test --no-selective-testing $SCHEME -- -sdk iphonesimulator -destination "$DESTINATION" -disableAutomaticPackageResolution CODE_SIGNING_ALLOWED='NO'