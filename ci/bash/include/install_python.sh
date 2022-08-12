get_default_python_version() {
    echo "3.9.4"
}

install_python_via_pyenv() {
    body() {
        local python_version; python_version=${1-$(get_default_python_version)}

        LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/readline/lib" \
        CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/readline/include" \
        pyenv install -s "$python_version"
    }

    { set +x; } 2>/dev/null && ci_log_block "Installing Python version $python_version" body ${@+"$@"}
}