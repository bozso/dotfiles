export temu=lxterminal
export BROWSER="chromium-browser"

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

pkgs="${HOME}/packages"
src="${pkgs}/src"
export github="${src}/github.com/bozso"
export bitbucket="${src}/bitbucket.org/ibozso"

export dotfiles="${github}/dotfiles"

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
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${pkgs}/usr/lib/x86_64-linux-gnu"

export OMP_NUM_THREADS=8

evaluate() {
    # printf "%s" "$*"
    eval "$*"
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

conda="${HOME}/miniconda3"
export conda_lib="${conda}/lib"
