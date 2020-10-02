#!/bin/bash
# Author: Christopher Breimo

# This script is useful for fetching multiple images at the same time from a Nexus repository
# It also exports the images to file, allowing you to move them to hosts that can't access the repo directly

## Variables
REPO=repo
IMGPREFIX=image-prefix
URL=https://"$IMGPREFIX"
read -r -p 'Enter a version number: ' VERSION

## Fetch all images available for the specified version
REQUEST=$(curl -s -k -X GET "$URL/service/rest/v1/search/assets?version=$VERSION&repository=$REPO" | grep -Po "\"v2\/$REPO\/\K([^\/]*)")

## Create and enter version directory
mkdir "$VERSION"/ && cd "$VERSION"/ || exit

## Pull and export all images for the specified version
for APP in $REQUEST
do
  # Pulls all the images returned by $REQUEST
  printf "[\033[0;36mPulling\033[0m]: \033[1;32m%s:%s\033[0m\n" "$APP" "$VERSION"
  docker pull "$IMGPREFIX"/"$REPO"/"$APP":"$VERSION" >> /dev/null
  
  # Exports the images to files
  printf "[\033[0;36mExporting\033[0m]: \033[1;32m%s:%s\033[0m -> \033[1;33m%s/%s-%s.tar\033[0m\n" "$APP" "$VERSION" "$VERSION" "$APP" "$VERSION"
  docker save -o "$APP"-"$VERSION".tar "$IMGPREFIX"/"$REPO"/"$APP":"$VERSION" >> /dev/null

  # Deletes the pulled images after exporting to file
  docker rmi "$IMGPREFIX"/"$REPO"/"$APP":"$VERSION" >> /dev/null
done

printf "\033[1;32mCompleted\033[0m\n"