source "$REPO_ROOT/ci/bash/include/ci_integration/base_ci_integration.sh"

if [ -z ${MIXBOX_CI_CI_SERVER_TYPE+x} ]; then
    # $MIXBOX_CI_CI_SERVER_TYPE is unset
    source "$REPO_ROOT/ci/bash/include/ci_integration/no_ci_integration.sh"
else
    case "$MIXBOX_CI_CI_SERVER_TYPE" in
    teamcity)
        source "$REPO_ROOT/ci/bash/include/ci_integration/teamcity_ci_integration.sh"
        ;;
    *)
        fatal_error "Unsupported \$MIXBOX_CI_CI_SERVER_TYPE: $MIXBOX_CI_CI_SERVER_TYPE"
        ;;
    esac
fi

