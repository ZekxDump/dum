#!/bin/bash

# Check if settings are set
if [ -z "$API_TOKEN" ] || [ -z "$REDDIT_USERNAME" ]; then
  echo -e "\033[31m[IMPORTANT]\033[0m No settings have been set. Please input your token and username."
  exit 1
fi

# Build the APK
./gradlew updateLintBaseline
./gradlew assembleRelease

# Move the APK to a known location
mv app/build/outputs/apk/release/app*.apk /content/Infinity.apk
