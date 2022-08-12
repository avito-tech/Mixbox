source "$REPO_ROOT/ci/bash/include/ci_integration/base_ci_integration.sh"

if [ -z ${CI_SERVER_TYPE+x} ]; then
    # $CI_SERVER_TYPE is unset
    source "$REPO_ROOT/ci/bash/include/ci_integration/no_ci_integration.sh"
else
    case "$CI_SERVER_TYPE" in
    teamcity)
        source "$REPO_ROOT/ci/bash/include/ci_integration/teamcity_ci_integration.sh"
        ;;
    *)
        fatal_error "Unsupported \$CI_SERVER_TYPE: $CI_SERVER_TYPE"
        ;;
    esac
fi

