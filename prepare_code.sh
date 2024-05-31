#!/bin/bash

# Set variables
API_TOKEN=$API_TOKEN
REDDIT_USERNAME=$REDDIT_USERNAME
REDIRECT_URI='http://127.0.0.1'
USER_AGENT="android:personal-app:0.0.1 (by /u/$REDDIT_USERNAME)"

# Check if settings are set
if [ -z "$API_TOKEN" ] || [ -z "$REDDIT_USERNAME" ]; then
  echo -e "\033[31m[IMPORTANT]\033[0m No settings have been set. Please input your token and username."
  exit 1
else
  echo "Following settings have been set:"
  echo "- User-Agent: $USER_AGENT"
  echo "- API token: $API_TOKEN"
  echo "- Redirect URI: $REDIRECT_URI"
fi

# Download project
wget "https://github.com/Docile-Alligator/Infinity-For-Reddit/archive/a46e96f3e48a89f7b683fa7308c39f01c5b5ac21.zip"
unzip "a46e96f3e48a89f7b683fa7308c39f01c5b5ac21.zip"
mv Infinity-For-Reddit-* Infinity-For-Reddit
cd Infinity-For-Reddit/

# Modify API settings
APIUTILS_FILE="app/src/main/java/ml/docilealligator/infinityforreddit/utils/APIUtils.java"
sed -i "s/NOe2iKrPPzwscA/$API_TOKEN/" $APIUTILS_FILE
sed -i "s|infinity://localhost|$REDIRECT_URI|" $APIUTILS_FILE
sed -i "s|public static final String USER_AGENT = \".*\";|public static final String USER_AGENT = \"$USER_AGENT\";|" $APIUTILS_FILE

# Add keystore
wget -P /content/ "https://github.com/TanukiAI/Infinity-keystore/raw/main/Infinity.jks"
BUILD_GRADLE_FILE="app/build.gradle"
sed -i '/buildTypes {/a \
    signingConfigs { \
        release { \
            storeFile file("/content/Infinity.jks") \
            storePassword "Infinity" \
            keyAlias "Infinity" \
            keyPassword "Infinity" \
        } \
    } \
' $BUILD_GRADLE_FILE
sed -i '/release {/a \
            signingConfig signingConfigs.release' $BUILD_GRADLE_FILE
sed -i '/lint {/a \
        baseline = file("lint-baseline.xml")' $BUILD_GRADLE_FILE
