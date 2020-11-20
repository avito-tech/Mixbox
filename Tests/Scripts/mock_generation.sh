#!/bin/bash

set -xueo pipefail

generate_and_log() {
    generate "$@" 2>&1 | tee "${PROJECT_DIR}/generate_mocks.ignored.log"
}

generate() {
    DESTINATION_MODULE=$1
    MOCKS_ROOT=$2

    echo "Started generation: $(date)"
    
    OUTPUT_FILE="${MOCKS_ROOT}/GeneratedMocks.ignored.swift"
    
    reset_before_applying_mocks
    APPLY_MOCKS_MODE="generate_all_files_list"
    apply_mocks
    
    calculate_files_affecting_code_generation
    
    local shasum_file="${MOCKS_ROOT}/mocks.shasum.ignored"
    local current_checksum=$((shasum "$0" "${ALL_FILES_TO_MOCK[@]}" "${FILES_AFFECTING_CODE_GENERATION[@]}") | shasum)
    local cached_checksum=$(cat "$shasum_file" || true)
    
    if [ "$current_checksum" != "$cached_checksum" ] || ! [ -e "$OUTPUT_FILE" ]
    then
        ignoring_all_errors rm -f "$OUTPUT_FILE"
    
        reset_before_applying_mocks
        APPLY_MOCKS_MODE="generate_mocks"
        apply_mocks
        complete_generation
    
        echo "$current_checksum" > "$shasum_file"
        
        echo "Generated Mocks File = ${OUTPUT_FILE}"
    fi
}

pipe_with_description() {
    shift 1
    "$@"
}

__GENERATOR_PATH=""
run_generator() {
    build_generator_if_needed
    "$__GENERATOR_PATH" "$@" || fatal_error "Generator failed"
}

calculate_files_affecting_code_generation() {
    if [ -z ${FILES_AFFECTING_CODE_GENERATION+unset} ]
    then
        FILES_AFFECTING_CODE_GENERATION=(
            "$REPO_ROOT/Tests/Scripts/mock_generation.sh"
            "$REPO_ROOT/Package.swift"
        )

        IFS=$'\n'
        for file in $(find "$REPO_ROOT/Frameworks/MocksGeneration" -type f; find "$REPO_ROOT/MocksGenerator" -type f)
        do
            FILES_AFFECTING_CODE_GENERATION=("${FILES_AFFECTING_CODE_GENERATION[@]}" "$file")
        done
    fi
}

build_generator_if_needed() {
    if [ -z "$__GENERATOR_PATH" ]
    then
        calculate_files_affecting_code_generation
        
        local configuration="release"
        __GENERATOR_PATH="$REPO_ROOT/.build/$configuration/MixboxMocksGenerator"

        local shasum_file="$REPO_ROOT/Tests/Scripts/generator.shasum.ignored"
        local current_checksum=$(shasum "${FILES_AFFECTING_CODE_GENERATION[@]}" | shasum)
        local cached_checksum=$(cat "$shasum_file" || true)
        
        if [ "$current_checksum" != "$cached_checksum" ] || ! [ -e "$__GENERATOR_PATH" ]
        then
            cd "$REPO_ROOT"
            
            env -i bash -lc "swift build --product MixboxMocksGenerator --configuration \"$configuration\"" || fatal_error

            echo "$current_checksum" > "$shasum_file"
            
            cd -
        fi
    fi
}

complete_generation() {
    if [ -z "$MODULE_TO_MOCK" ]
    then
        return 0
    fi
    
    local tmpfile="$(uuidgen).tmp"
    
    run_generator \
        "$MODULE_TO_MOCK" \
        "$DESTINATION_MODULE" \
        "${tmpfile}"  \
        "${ALL_FILES_TO_MOCK[@]}" || fatal_error "Generator failed"
    
    cat "${tmpfile}" >> "${OUTPUT_FILE}"
    
    echo >> "$OUTPUT_FILE"
    
    rm "${tmpfile}"
}

fatal_error() {
    local last_error_code=$?
    [ $# == 0 ] && echo "Fatal error. Exit code: $last_error_code"
    echo $@
    exit $last_error_code
}

ignoring_all_errors() {
    "$@" 1>/dev/null 2>/dev/null || true
}

reset_before_applying_mocks() {
    ALL_FILES_TO_MOCK=()
    MODULE_TO_MOCK=
}

# DSL functions

mock() {
    [ -z "$MODULE_TO_MOCK" ] && fatal_error "call 'module' before 'mock'"

    local class=$1
    
    if [[ "$MODULE_TO_MOCK" == Mixbox* ]]
    then
        local framework_folder=$(echo $MODULE_TO_MOCK | sed 's/^Mixbox//')
        local file_to_mock=$(find "${REPO_ROOT}/Frameworks/$framework_folder" -name "${class}.swift")
    else
        local file_to_mock=$(find "${REPO_ROOT}" -name "${class}.swift")
    fi
    
    ALL_FILES_TO_MOCK=("${ALL_FILES_TO_MOCK[@]+"${ALL_FILES_TO_MOCK[@]}"}" "${file_to_mock}")
}

module() {
    case "$APPLY_MOCKS_MODE" in
        generate_all_files_list)
            MODULE_TO_MOCK=$1
            ;;
        generate_mocks)
            complete_generation
            
            ALL_FILES_TO_MOCK=()
            MODULE_TO_MOCK=$1
            ;;
        *)
            fatal_error "Unknown APPLY_MOCKS_MODE: $APPLY_MOCKS_MODE"
            ;;
    esac
}
