progs="${HOME}/progs"
dotfiles="${progs}/github.com/dotfiles"

alias reload='. ${dotfiles}/config.sh'
alias menu='sh ${dotfiles}/menu.sh modules'

export temu=lxterminal
browser="chromium-browser"

for file in $(ls ${dotfiles}/bash_completion/); do
    if [ -r ${file} ]; then
        . ${file}
    fi
done


pkgs="${HOME}/packages"

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


goroot="${HOME}/go/src/github.com/bozso"

paths=\
"
${progs}/github.com/stm-bi
${progs}/github.com/insar_meteo
${progs}/github.com/pygomma
${progs}/github.com/utils
${progs}/bitbucket.org/stm-bi
"

for path in ${paths}; do
    p="${path}/init.sh"
    if [ -f "${p}" ]; then
        source "${p}" "${path}"
    fi
done

export PATH="${PATH}:${pkgs}/usr/bin:${HOME}/.nimble/bin:${HOME}/go/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${pkgs}/usr/lib/x86_64-linux-gnu"

export OMP_NUM_THREADS=8
