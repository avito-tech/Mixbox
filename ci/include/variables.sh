# MIXBOX_CI_CACHE
#   To debug locally, enum (optional): "regenerate", "use"
#
# MIXBOX_CI_REPORTS_PATH
#   Where to store reports (junit.xml will be stored)
#
# MIXBOX_CI_DESTINATION
#   Path to json file

MIXBOX_CI_SCRIPT_DIRECTORY=$(cd "$(dirname $0)"; pwd)
MIXBOX_CI_REPO_ROOT=$(cd "$MIXBOX_CI_SCRIPT_DIRECTORY"; git rev-parse --show-toplevel)

# Random number. Unique for script that includes this file.
if [ -z "$MIXBOX_CI_CACHE" ]
then
    MIXBOX_CI_TEMPORARY_DIRECTORY=/tmp/`uuidgen`
else
    MIXBOX_CI_TEMPORARY_DIRECTORY=/tmp/$(echo $0|shasum|grep -oE "^\w+")
fi

derivedDataPath() {
    [ -z "$MIXBOX_CI_TEMPORARY_DIRECTORY" ] && fatalError "\$MIXBOX_CI_TEMPORARY_DIRECTORY is not set"
    
    echo "$MIXBOX_CI_TEMPORARY_DIRECTORY/dd"
}

echo "Reproduce this build:"
echo
echo "$(env | grep -E "^(MIXBOX_|EMCEE_)" | tr "\n" " ") $0"
echo