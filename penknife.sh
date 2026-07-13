#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: a2cc83d
[ "$EUID" -ne 0 ] && { { command -v sudo >/dev/null 2>&1 && __sudo=sudo; } || { command -v doas >/dev/null 2>&1 && __sudo=doas; }; }
if [ -n "$ZSH_VERSION" ]; then
    EXEC_SHELL="zsh"
    IFS='.' read -A EXEC_SHELL_VERSION <<< "$ZSH_VERSION"
elif [ -n "$KSH_VERSION" ]; then
    EXEC_SHELL="ksh"
    __exec_shell_version="${.sh.version##*/}"
    IFS='.' read -a EXEC_SHELL_VERSION <<< "${__exec_shell_version%% *}"
else
    EXEC_SHELL="bash"
    EXEC_SHELL_VERSION=("${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}")
fi
# has_failed(command: Text)
has_failed__126_v0() {
    local command_6="${1}"
    eval ${command_6}>/dev/null 2>&1
    __status=$?
    ret_has_failed126_v0="$(( __status != 0 ))"
    return 0
}

# Installer template for heider.cc tools.
# 
# Compiled per tool by gen-installers.sh (Amber -> bash) into /<name>.sh at
# the site root, served as `curl -fsSL https://heider.cc/<name>.sh | sh`.
# Do not edit the generated .sh files by hand; edit this and regenerate.
# 
# Relies on the uniform jhheider release asset naming:
# <name>-{linux,macos}-{aarch64,x86_64}.tar.gz
name_3="penknife"
repo_4="jhheider/penknife"
# get_os()
get_os__158_v0() {
    local command_0
    command_0="$(uname -s)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        printf '%s\n' "${name_3}: failed to detect OS (is \`uname\` available?)"
        exit 1
    fi
    local os_type_9="${command_0}"
    if [ "$([ "_${os_type_9}" != "_Darwin" ]; echo $?)" != 0 ]; then
        ret_get_os158_v0="macos"
        return 0
    fi
    if [ "$([ "_${os_type_9}" == "_Linux" ]; echo $?)" != 0 ]; then
        printf '%s\n' "${name_3}: unsupported OS: ${os_type_9}"
        echo "Prebuilt binaries for other platforms live at:"
        echo "  https://github.com/${repo_4}/releases/latest"
        exit 1
    fi
    ret_get_os158_v0="linux"
    return 0
}

# get_arch()
get_arch__159_v0() {
    local command_1
    command_1="$(uname -m)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        printf '%s\n' "${name_3}: failed to detect CPU architecture."
        exit 1
    fi
    local arch_type_12="${command_1}"
    if [ "$([ "_${arch_type_12}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_arch159_v0="aarch64"
        return 0
    fi
    if [ "$([ "_${arch_type_12}" != "_aarch64" ]; echo $?)" != 0 ]; then
        ret_get_arch159_v0="aarch64"
        return 0
    fi
    if [ "$([ "_${arch_type_12}" == "_x86_64" ]; echo $?)" != 0 ]; then
        printf '%s\n' "${name_3}: unsupported architecture: ${arch_type_12}"
        echo "Prebuilt binaries live at:"
        echo "  https://github.com/${repo_4}/releases/latest"
        exit 1
    fi
    ret_get_arch159_v0="x86_64"
    return 0
}

has_failed__126_v0 "curl -V"
ret_has_failed126_v0__50_8="${ret_has_failed126_v0}"
if [ "${ret_has_failed126_v0__50_8}" != 0 ]; then
    printf '%s\n' "${name_3}: \`curl\` is required. Please install it and try again."
    exit 1
fi
command_3="$(echo $HOME)"
__status=$?
home_7="${command_3}"
if [ "$([ "_${home_7}" != "_" ]; echo $?)" != 0 ]; then
    printf '%s\n' "${name_3}: unable to determine your home directory (\$HOME)."
    exit 1
fi
get_os__158_v0 
os_10="${ret_get_os158_v0}"
get_arch__159_v0 
arch_13="${ret_get_arch159_v0}"
asset_14="${name_3}-${os_10}-${arch_13}.tar.gz"
url_15="https://github.com/${repo_4}/releases/latest/download/${asset_14}"
bin_dir_16="${home_7}/.local/bin"
command_4="$(mktemp -d)"
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: failed to create a temporary directory."
    exit 1
fi
tmp_17="${command_4}"
echo "Downloading ${asset_14} from the latest ${repo_4} release..."
curl -fL -o "${tmp_17}/${asset_14}" "${url_15}">/dev/null 2>&1
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: download failed: ${url_15}"
    echo "Check https://github.com/${repo_4}/releases/latest for assets."
    exit 1
fi
tar -xzf "${tmp_17}/${asset_14}" -C "${tmp_17}">/dev/null 2>&1
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: failed to unpack ${asset_14}."
    exit 1
fi
mkdir -p "${bin_dir_16}">/dev/null 2>&1
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: failed to create ${bin_dir_16}."
    exit 1
fi
mv "${tmp_17}/${name_3}" "${bin_dir_16}/${name_3}"
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: failed to move the binary into ${bin_dir_16}."
    exit 1
fi
chmod +x "${bin_dir_16}/${name_3}"
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' "${name_3}: failed to mark ${bin_dir_16}/${name_3} executable."
    exit 1
fi
rm -rf "${tmp_17}">/dev/null 2>&1
__status=$?
command_5="$("${bin_dir_16}/${name_3}" --version)"
__status=$?
version_18="${command_5}"
echo "Installed ${version_18} -> ${bin_dir_16}/${name_3}"
echo ":$PATH:" | grep -q ":${bin_dir_16}:">/dev/null 2>&1
__status=$?
if [ "${__status}" != 0 ]; then
    printf '%s\n' ""
    echo "Note: ${bin_dir_16} is not on your PATH. Add this to your shell rc:"
    echo "  export PATH=\"${bin_dir_16}:\$PATH\""
fi
