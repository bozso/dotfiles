export temu=lxterminal
export BROWSER="chromium-browser"

pkgs="${HOME}/packages"
src="${pkgs}/src"
pkgs_bin="${pkgs}/usr/bin"

export github="${src}/github.com/bozso"
export bitbucket="${src}/bitbucket.org/ibozso"
export srht="${src}/sr.ht"

export dotfiles="${github}/dotfiles"

storage() {
    sudo mount //storage/bozsoi ${HOME}/mount/storage/ -o user=bozsoi,dir_mode=0777,file_mode=0666
}

ossl="openssl"

get_page() {
    local url="$1"
    echo "$(echo -n | ${ossl} s_client -showcerts -connect ${url})"
}

get_cert() {
    local url="$1"

    $(get_page "${url}") 2>/dev/null | \
        sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
}

bw_impl() {
    local target="$1"

    local sel="$(rbw list | fzf)"
    [ -z "${sel}" ] && return
    rbw get "${sel}" | xclip -i -selection "${target}"
}

preb() {
    local py="python3"
    local file="${dotfiles}/prebuilt_binaries.py"

    ${py} ${file} $*
}

bwp() {
    bw_impl "primary"
}

tmws() {
    workspace $*
}

alias bw="bwp"
alias rg="rigrep"

bw_c() {
    bw_impl "clipboard"
}

gen_repos() {
    gotoolbox genrepos \
        -config "configs/repository_settings.json" \
        -out "configs/local_repos.json"
}

report() {
    gotoolbox repositories \
        -command status \
        -html -out "/tmp/git_report.html" \
        -config "${gh}/dotfiles/configs/local_repos.json"
}

local_install() {
    if [ "$#" != "1" ]; then
        printf "error: local_install: One argument (package name) is required!\n" >&2
        return 1
    fi

    rm *.deb

    apt download $1
    mkdir -p "${pkgs}"

    dpkg -x *.deb "${pkgs}"

    rm *.deb
}

tar_com() {
    tar -czvf $1.tar.gz $1
}

tar_ext() {
    tar -xzvf $1.tar.gz $1
}

gm() {
    sh ${dotfiles}/git.sh $*
}


proton() {
    check_narg $# 1

    local p_sapps="/home/istvan/.steam/steam/steamapps"
    local p_compat="$p_sapps/compatdata/eofs"
    local e_proton="$p_sapps/common/Proton 3.16/proton"
    local p_freetype="/usr/lib/x86_64-linux-gnu/libfreetype.so.6"

    # STEAM_COMPAT_DATA_PATH="/home/istvan/.proton/" python "$e_proton" run $1 LD_PRELOAD=$p_freetype
    # PROTON_USE_WINED3D11=1 \
    # PROTON_NO_ESYNC=1 \
    STEAM_COMPAT_DATA_PATH=$p_compat \
    DXVK_LOG_LEVEL=debug \
    python "$e_proton" run $1

}

alias nano="nano -u"
alias nbrc="nano -u ~/.bashrc"
alias fm="nnn -d -R"
alias tb="gotoolbox"
alias mage="tb mage"
alias light="sudo ${pkgs_bin}/xbacklight -set"


alias reload='. ${dotfiles}/config.sh'
alias menu='sh ${dotfiles}/menu.sh modules'
alias import='sh ${dotfiles}/menu.sh import'

paths=\
"
${github}/insar_meteo
${github}/pygomma
${github}/utils
${bitbucket}/stmpy
${bitbucket}/stm-bi
"

for path in ${paths}; do
    p="${path}/init.sh"

    if [ -f "${p}" ]; then
        sh "${p}" "${path}"
    fi
done


# Disable ascii coloring as geany's compiler message panel can not
# handle them at the moment
export NO_COLOR=1

export GOPATH="${pkgs}"
export PATH="${PATH}:${pkgs}/usr/bin:${pkgs}/bin:${HOME}/.nimble/bin"
export PATH="${PATH}:${dotfiles}/bin:/opt/cisco/anyconnect/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${pkgs}/usr/lib"

export OMP_NUM_THREADS=8

evaluate() {
    # printf "%s" "$*"
    eval "$*"
}

mount_storage() {
    local storage=/home/istvan/mount/storage
    mkdir -p "${storage}"

    sudo mount //storage/bozsoi "${storage}" \
        -o user=bozsoi,dir_mode=0777,file_mode=0666
}

compress_pdf() {
    local in="$1"
    local out="$2"

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET \
        -dBATCH -dPrinted=false \
        -sOutputFile="${out}" "${in}"
}

simple_ps() {
    PS1="\u@\H\n"
}

eval_if_dir() {
    if [ -d "$1" ]; then
        evaluate "$2"
    fi
}

eval_if_file() {
    if [ -f "$1" ]; then
        evaluate "$2"
    fi
}

evaluate "$(starship init bash)"

eval_if_file "starship" "$(starship init bash)"
eval_if_dir "${HOME}/bake/bake" "${HOME}/bake/bake env"

# source a file if it exists
source_if() {
    if [ -f "$1" ]; then
        . "$1"
    fi
}

source_if "${HOME}/.nix-profile/etc/profile.d/nix.sh"
source_if "${HOME}/.cargo/env"
source_if "${HOME}/.xmake/profile"

down="${pkgs}/downloaded"
clang="${down}/clang/lib"

if [ -d "${clang}" ]; then
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${clang}"
fi

source_if "${dotfiles}/tmux_workspace.sh"

conda="${HOME}/miniconda3"
export conda_lib="${conda}/lib"

node_path="${down}/node/v14.18.0"
node_bin="${node_path}/bin"

export PATH="${PATH}:${node_bin}"

if [ -f "${node_bin}" ]; then
    export PATH="${PATH}:${node_bin}"
fi

. "${dotfiles}/manage.sh"
source_if "/home/istvan/.sdkman/bin/sdkman-init.sh"
source_if "${HOME}/.config/paths_gen.sh"

mm_setup() {
    eval "$(micromamba shell hook -s bash)"
}

alias mm="micromamba"
