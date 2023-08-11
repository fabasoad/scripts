#!/usr/bin/env bash

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_BASE_FOLDER_PATH=$(dirname "$SCRIPT_PATH")

# shellcheck source=src/common.sh
. "$SCRIPTS_BASE_FOLDER_PATH/common.sh"

src=$1

for f in "${src}"/*
do
  if [ ! -d "$f" ]; then
    full_date=$(GetFileInfo -d "$f")

    creation_date=$(echo "${full_date}" | cut -d' ' -f 1)
    IFS='/' read -r -a creation_date_arr <<< "${creation_date}"
    year=${creation_date_arr[2]}
    month=${creation_date_arr[0]}
    day=${creation_date_arr[1]}

    creation_time=$(echo "${full_date}" | cut -d' ' -f 2)
    IFS=':' read -r -a creation_time_arr <<< "${creation_time}"
    hr=${creation_time_arr[0]}
    min=${creation_time_arr[1]}
    sec=${creation_time_arr[2]}

    old_filename=$(basename -- "$f")
    ext="${old_filename##*.}"

    new_folder="${year}.${month}.${day}"
    mkdir -p "${src}/${new_folder}"
    new_filename="${year}-${month}-${day}_${hr}-${min}-${sec}.${ext}"
    new_location="${src}/${new_folder}/${new_filename}"
    mv "$f" "$new_location"
    logInfo "$(basename "$0")" "Moved $old_filename to ${new_folder}/${new_filename}"
  fi
done
