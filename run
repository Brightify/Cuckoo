#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
FILE_NAME="cuckoo_generator"
FILE_PATH="$SCRIPT_PATH/$FILE_NAME"
GREP_OPTIONS=""

function perform_curl {
  if [[ ! -z "$GITHUB_ACCESS_TOKEN" ]]; then
    CURL_OPTIONS=(-H "Authorization: token $GITHUB_ACCESS_TOKEN")
  fi

  DOWNLOAD_URL=$(curl "${CURL_OPTIONS[@]}" "$1" | grep -oe '"browser_download_url":\s*"[^" ]*"' | grep -oe 'http[^" ]*' | grep "$FILE_NAME" | head -1)

  if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "Error: Failed to fetch download URL for the Cuckoo Generator."
    exit 1
  else
    echo "Downloading Cuckoo Generator from URL: $DOWNLOAD_URL"
    curl "${CURL_OPTIONS[@]}" -Lo "$FILE_PATH" "$DOWNLOAD_URL"
  fi
}

function download_generator {
  if [[ "$1" = "latest" ]]; then
    echo "Downloading latest version..."
    perform_curl "https://api.github.com/repos/Brightify/Cuckoo/releases/latest"
  else
    echo "Downloading version $1..."
    perform_curl "https://api.github.com/repos/Brightify/Cuckoo/releases/tags/$1"
  fi
  chmod +x "$FILE_NAME"
}

function build_generator {
  pushd "$SCRIPT_PATH"
  if [[ ! -z "$1" ]]; then
    download_generator "$1"
  else
    if [[ -d "$SCRIPT_PATH/Generator" ]]; then
      echo "Building..."
      ./build_generator
      if [[ "$?" -ne 0 ]]; then
        echo "Build seems to have failed for some reason. Please file an issue on GitHub."
        exit 1
      fi
      mv "$SCRIPT_PATH/Generator/.build/release/$FILE_NAME" "$FILE_PATH"
    else
      echo "Couldn't build. Generator source code not found. (expected in the 'Generator' directory)"
      download_generator "$2"
    fi
  fi
  popd
}

echo "Script path: $SCRIPT_PATH"

# parse arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
case $1 in
  -d|--download)
    if [[ "$2" = "latest" ]]; then
      DOWNLOAD="latest"
      shift
    else
      DOWNLOAD=$(echo "$2" | grep -e "\d\d*\.\d\d*\.\d\d*")
      if [[ ! -z $DOWNLOAD ]]; then
        shift
      else
        DOWNLOAD="latest"
      fi
    fi
    shift
  ;;

  -c|--clean)
    CLEAN=1
    echo "Performing clean build."
    shift
  ;;

  *)
    POSITIONAL+=("$1") # save it in an array for later
    shift
  ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ! -e "$FILE_PATH" ]] || [[ ! -z "$CLEAN" ]]; then
  echo "No Cuckoo Generator found."
  build_generator "$DOWNLOAD"
fi

INPUT_FILES=""
if [[ "$#" > 0 ]]; then
  INPUT_FILES=$(printf '%q ' "$@")
fi

if [[ -z "$SCRIPT_INPUT_FILE_COUNT" ]]; then
  SCRIPT_INPUT_FILE_COUNT=0
fi

for (( i=0; i<"$SCRIPT_INPUT_FILE_COUNT"; i++ ))
do
  INPUT_FILE="SCRIPT_INPUT_FILE_$i"
  INPUT_FILES+=" $(printf '%q' "${!INPUT_FILE}")"
done

echo $INPUT_FILES | xargs "$FILE_PATH"
