upload_hashed_zipped_for_emcee() {
    local file=$1
    
    filename=$(basename -- "$file")
    extension=${filename##*.}
    filename=${filename%.*}
    
    local sum=$(checksum "$file")
    
    upload_zipped_for_emcee "${file}" "${filename}-${sum}.${extension}"
}

upload_zipped_for_emcee() {
    local file=$1
    local remoteName=${2:-$(basename $file)}
    
    local temporaryDirectory=/tmp/`uuidgen`
    mkdir -p "$temporaryDirectory"
    
    pushd . 1>/dev/null 2>/dev/null
    cd "$(dirname "$file")" 1>/dev/null 2>/dev/null
    local basename=$(basename "$file")
    
    zip -r "$temporaryDirectory/$remoteName.zip" "$basename" 1>/dev/null 2>/dev/null
    remoteZip=$(upload "$temporaryDirectory/$remoteName.zip" "$remoteName.zip")
    
    popd 1>/dev/null 2>/dev/null
    
    # Emcee notation for files in zip
    echo "${remoteZip}#${basename}"
}

__MIXBOX_CI_UPLOADER_EXECUTABLE=
upload() {
    if [ -z "$__MIXBOX_CI_UPLOADER_EXECUTABLE" ]
    then
        [ -z "$MIXBOX_CI_FILE_UPLOADER_URL" ] && fatalError "MIXBOX_CI_FILE_UPLOADER_URL is not set"
        __MIXBOX_CI_UPLOADER_EXECUTABLE=`download $MIXBOX_CI_FILE_UPLOADER_URL`
    fi
    
    chmod +x "$__MIXBOX_CI_UPLOADER_EXECUTABLE"
    "$__MIXBOX_CI_UPLOADER_EXECUTABLE" "$@"
}

download() {
    local url=$1
    local tempFile=/tmp/`uuidgen`
    
    curl "$url" -o "$tempFile" 1>/dev/null
    
    echo "$tempFile"
}

# supports folders
checksum() {
    local file=$1
    
    find "$file" -type f -print0 \
        | sort -z \
        | xargs -0 shasum \
        | shasum \
        | grep -oE "^\S+"
}