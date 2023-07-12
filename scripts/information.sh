#!/usr/bin/env bash
#
# information.sh [-a] [-m] [config name]
#
# Generate a Neovim configuration information page from the command line
# If no configuraton name is given, use 'nvim-Lazyman'
#
# Generated information documents are stored in ~/.config/nvim-Lazyman/info/
# Info documents generated by this script are in Markdown format
# Use mkinfohtml.sh to generate HTML versions using pandoc

CF_NAMES="Lazyman Abstract AstroNvimPlus BasicIde Ecovim LazyVim LunarVim NvChad Penguin SpaceVim MagicVim AlanVim Allaman CatNvim Go Go2one Knvim LaTeX LazyIde LunarIde LvimIde Magidc Nv NV-IDE Python Rust SaleVim Shuvro Webdev 3rd Adib Brain Charles Craftzdog Dillon Elianiva Enrique Heiker J4de Josean Daniel LvimAdib Metis Mini ONNO OnMyWay Optixal Rafi Roiz Simple Slydragonn Spider Traap xero Xiao BasicLsp BasicMason Extralight LspCmp Minimal StartBase Opinion StartLsp StartMason Modular 2k AstroNvimStart Basic CodeArt Cosmic Ember Fennel HardHacker JustinLvim JustinNvim Kabin Kickstart Lamia Micah Normal NvPak Modern pde Rohit Scratch SingleFile"

LMANDIR="${HOME}/.config/nvim-Lazyman"
LOGDIR="${LMANDIR}/logs"
PLURLS="${LMANDIR}/scripts/plugin_urls.txt"
[ -d "${LOGDIR}" ] || mkdir -p "${LOGDIR}"

usage() {
  printf "\n\nUsage: information.sh [-a] [nvim-conf]\n\n"
  exit 1
}

get_plugins() {
  nvimdir="$1"
  outfile="$2"
  plugman="$3"
  confdir=
  if [ -d "${HOME}/.config/${nvimdir}" ]
  then
    confdir="${HOME}/.config/${nvimdir}"
  else
    [ -d "${HOME}/.config/nvim-${nvimdir}" ] && {
      confdir="${HOME}/.config/nvim-${nvimdir}"
    }
  fi
  [ "${confdir}" ] && {
    case ${plugman} in
      Lazy)
        [ -f "${confdir}/lazy-lock.json" ] && {
          echo "### Lazy managed plugins" >> "${outfile}"
          echo "" >> "${outfile}"
          grep ':' "${confdir}/lazy-lock.json" | awk -F ':' ' { print $1 } ' | \
          sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
          sed -e 's/"//g' -e "s/'//g" | while read plug
          do
            url=$(grep ${plug} ${PLURLS} | head -1)
            if [ "${url}" ]
            then
              plugin=$(echo ${url} | awk -F '/' ' { print $(NF - 1)"/"$(NF) } ')
              echo "- [${plugin}](${url})" >> "${outfile}"
            else
              echo "- ${plug}" >> "${outfile}"
            fi
          done
        }
        ;;
      Packer)
        echo "### Packer managed plugins" >> "${outfile}"
        echo "" >> "${outfile}"
        find "${confdir}" -name packer_compiled.lua -print0 | \
        xargs -0 grep url | grep = | awk -F '=' ' { print $2 } ' | \
        sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
        sed -e 's/"//g' -e "s/'//g" | while read url
        do
          plugin=$(echo ${url} | awk -F '/' ' { print $(NF - 1)"/"$(NF) } ')
          echo "- [${plugin}](${url})" >> "${outfile}"
        done
        ;;
      Plug)
        echo "### Plug managed plugins" >> "${outfile}"
        echo "" >> "${outfile}"
        echo "- TBD" >> "${outfile}"
        ;;
      *)
        echo "### Unsupported plugin manager" >> "${outfile}"
        ;;
    esac
  }
}

make_info() {
  nvimconf="$1"
  INFO="${nvimconf}.md"
  OUTF="${HOME}/src/Neovim/nvim-lazyman/info/${INFO}"

  GH_URL=
  NC_URL=
  DF_URL=
  WS_URL=
  CF_CAT="Unknown"
  CF_TYP="Custom"
  PL_MAN="Lazy"
  case ${nvimconf} in
    Lazyman)
      GH_URL="https://github.com/doctorfree/nvim-lazyman"
      NC_URL="http://neovimcraft.com/plugin/doctorfree/nvim-lazyman"
      DF_URL="https://dotfyle.com/doctorfree/nvim-lazyman"
      CF_CAT="Default"
      ;;
    Abstract)
      GH_URL="https://github.com/Abstract-IDE/Abstract"
      NC_URL="https://neovimcraft.com/plugin/Abstract-IDE/Abstract"
      DF_URL="https://dotfyle.com/plugins/Abstract-IDE/Abstract"
      WS_URL="https://abstract-ide.github.io/site"
      CF_CAT="Base"
      PL_MAN="Packer"
      ;;
    AstroNvimPlus)
      GH_URL="https://github.com/doctorfree/astronvim"
      CF_CAT="Base"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    BasicIde)
      GH_URL="https://github.com/LunarVim/nvim-basic-ide"
      CF_CAT="Base"
      ;;
    Ecovim)
      GH_URL="https://github.com/ecosse3/nvim"
      NC_URL="http://neovimcraft.com/plugin/ecosse3/nvim"
      CF_CAT="Base"
      ;;
    LazyVim)
      GH_URL="https://github.com/LazyVim LazyVim/starter"
      CF_CAT="Base"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    LunarVim)
      GH_URL="https://github.com/IfCodingWereNatural/minimal-nvim"
      CF_CAT="Base"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    NvChad)
      GH_URL="https://github.com/doctorfree/NvChad-custom"
      CF_CAT="Base"
      CF_TYP="[NvChad](https://nvchad.com)"
      ;;
    Penguin)
      GH_URL="https://github.com/p3nguin-kun/penguinVim"
      CF_CAT="Base"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    SpaceVim)
      GH_URL="https://github.com/doctorfree/spacevim"
      CF_CAT="Base"
      CF_TYP="[SpaceVim](https://spacevim.org)"
      ;;
    MagicVim)
      GH_URL="https://gitlab.com/GitMaster210/magicvim"
      CF_CAT="Base"
      ;;
    AlanVim)
      GH_URL="https://github.com/alanRizzo/dot-files"
      CF_CAT="Language"
      PL_MAN="Packer"
      ;;
    Allaman)
      GH_URL="https://github.com/Allaman/nvim"
      DF_URL="https://dotfyle.com/Allaman/nvim"
      CF_CAT="Language"
      ;;
    CatNvim)
      GH_URL="https://github.com/nullchilly/CatNvim"
      DF_URL="https://dotfyle.com/nullchilly/catnvim"
      CF_CAT="Language"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    Go)
      GH_URL="https://github.com/dreamsofcode-io/neovim-go-config"
      CF_CAT="Language"
      CF_TYP="[NvChad](https://nvchad.com)"
      ;;
    Go2one)
      GH_URL="https://github.com/leoluz/go2one"
      CF_CAT="Language"
      ;;
    Knvim)
      GH_URL="https://github.com/knmac/knvim"
      DF_URL="https://dotfyle.com/knmac/knvim"
      CF_CAT="Language"
      ;;
    LaTeX)
      GH_URL="https://github.com/benbrastmckie/.config"
      NC_URL="http://neovimcraft.com/plugin/benbrastmckie/.config"
      CF_CAT="Language"
      PL_MAN="Packer"
      ;;
    LazyIde)
      GH_URL="https://github.com/doctorfree/nvim-LazyIde"
      CF_CAT="Language"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    LunarIde)
      GH_URL="https://github.com/doctorfree/lvim-Christian"
      CF_CAT="Language"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    LvimIde)
      GH_URL="https://github.com/lvim-tech/lvim"
      NC_URL="http://neovimcraft.com/plugin/lvim-tech/lvim"
      CF_CAT="Language"
      ;;
    Magidc)
      GH_URL="https://github.com/magidc/nvim-config"
      CF_CAT="Language"
      ;;
    Nv)
      GH_URL="https://github.com/appelgriebsch/Nv"
      NC_URL="http://neovimcraft.com/plugin/appelgriebsch/Nv"
      DF_URL="https://dotfyle.com/appelgriebsch/nv"
      CF_CAT="Language"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    NV-IDE)
      GH_URL="https://github.com/crivotz/nv-ide"
      NC_URL="http://neovimcraft.com/plugin/crivotz/nv-ide"
      DF_URL="https://dotfyle.com/crivotz/nv-ide"
      CF_CAT="Language"
      ;;
    Python)
      GH_URL="https://github.com/dreamsofcode-io/neovim-python"
      CF_CAT="Language"
      CF_TYP="[NvChad](https://nvchad.com)"
      ;;
    Rust)
      GH_URL="https://github.com/dreamsofcode-io/neovim-rust"
      CF_CAT="Language"
      CF_TYP="[NvChad](https://nvchad.com)"
      ;;
    SaleVim)
      GH_URL="https://github.com/igorcguedes/SaleVim"
      CF_CAT="Language"
      PL_MAN="Packer"
      ;;
    Shuvro)
      GH_URL="https://github.com/shuvro/lvim"
      CF_CAT="Language"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    Webdev)
      GH_URL="https://github.com/doctorfree/nvim-webdev"
      CF_CAT="Language"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    3rd)
      GH_URL="https://github.com/3rd/config"
      DF_URL="https://dotfyle.com/3rd/config-home-dotfiles-nvim"
      CF_CAT="Personal"
      ;;
    Adib)
      GH_URL="https://github.com/adibhanna/nvim"
      NC_URL="http://neovimcraft.com/plugin/adibhanna/nvim"
      CF_CAT="Personal"
      ;;
    Brain)
      GH_URL="https://github.com/brainfucksec/neovim-lua"
      NC_URL="http://neovimcraft.com/plugin/brainfucksec/neovim-lua"
      CF_CAT="Personal"
      ;;
    Charles)
      GH_URL="https://github.com/CharlesChiuGit/nvimdots.lua"
      CF_CAT="Personal"
      ;;
    Craftzdog)
      GH_URL="https://github.com/craftzdog/dotfiles-public"
      DF_URL="https://dotfyle.com/craftzdog/dotfiles-public-config-nvim"
      CF_CAT="Personal"
      ;;
    Dillon)
      GH_URL="https://github.com/dmmulroy/dotfiles"
      CF_CAT="Personal"
      ;;
    Elianiva)
      GH_URL="https://github.com/elianiva/dotfiles"
      CF_CAT="Personal"
      ;;
    Enrique)
      GH_URL="https://github.com/kiyov09/dotfiles"
      CF_CAT="Personal"
      ;;
    Heiker)
      GH_URL="https://github.com/VonHeikemen/dotfiles"
      CF_CAT="Personal"
      ;;
    J4de)
      GH_URL="https://codeberg.org/j4de/nvim"
      CF_CAT="Personal"
      ;;
    Josean)
      GH_URL="https://github.com/josean-dev/dev-environment-files"
      CF_CAT="Personal"
      PL_MAN="Packer"
      ;;
    Daniel)
      GH_URL="https://github.com/daniel-vera-g/lvim"
      CF_CAT="Personal"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    LvimAdib)
      GH_URL="https://github.com/adibhanna/lvim-config"
      CF_CAT="Personal"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    Metis)
      GH_URL="https://github.com/metis-os/pwnvim"
      CF_CAT="Personal"
      ;;
    Mini)
      GH_URL="https://github.com/echasnovski/nvim"
      NC_URL="http://neovimcraft.com/plugin/echasnovski/nvim"
      CF_CAT="Personal"
      ;;
    ONNO)
      GH_URL="https://github.com/loctvl842/nvim"
      DF_URL="https://dotfyle.com/loctvl842/nvim"
      CF_CAT="Personal"
      ;;
    OnMyWay)
      GH_URL="https://github.com/RchrdAlv/NvimOnMy_way"
      CF_CAT="Personal"
      ;;
    Optixal)
      GH_URL="https://github.com/Optixal/neovim-init.vim"
      NC_URL="http://neovimcraft.com/plugin/Optixal/neovim-init.vim"
      CF_CAT="Personal"
      PL_MAN="Plug"
      ;;
    Rafi)
      GH_URL="https://github.com/rafi/vim-config"
      DF_URL="https://dotfyle.com/rafi/vim-config"
      CF_CAT="Personal"
      ;;
    Roiz)
      GH_URL="https://github.com/MrRoiz/rnvim"
      CF_CAT="Personal"
      ;;
    Simple)
      GH_URL="https://github.com/anthdm/.nvim"
      CF_CAT="Personal"
      PL_MAN="Packer"
      ;;
    Slydragonn)
      GH_URL="https://github.com/slydragonn/dotfiles"
      CF_CAT="Personal"
      PL_MAN="Packer"
      ;;
    Spider)
      GH_URL="https://github.com/fearless-spider/FSAstroNvim"
      CF_CAT="Personal"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    Traap)
      GH_URL="https://github.com/Traap/nvim"
      CF_CAT="Personal"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    xero)
      GH_URL="https://github.com/xero/dotfiles"
      NC_URL="http://neovimcraft.com/plugin/xero/dotfiles"
      DF_URL="https://dotfyle.com/xero/dotfiles-neovim-config-nvim"
      CF_CAT="Personal"
      ;;
    Xiao)
      GH_URL="https://github.com/onichandame/nvim-config"
      CF_CAT="Personal"
      ;;
    BasicLsp)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/xx-basic-lsp"
      CF_CAT="Starter"
      ;;
    BasicMason)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/xx-mason"
      CF_CAT="Starter"
      ;;
    Extralight)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/xx-light"
      CF_CAT="Starter"
      ;;
    LspCmp)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/xx-lsp-cmp"
      CF_CAT="Starter"
      ;;
    Minimal)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/00-minimal"
      CF_CAT="Starter"
      ;;
    StartBase)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/01-base"
      CF_CAT="Starter"
      ;;
    Opinion)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/02-opinionated"
      CF_CAT="Starter"
      ;;
    StartLsp)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/03-lsp"
      CF_CAT="Starter"
      ;;
    StartMason)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/04-lsp-installer"
      CF_CAT="Starter"
      ;;
    Modular)
      GH_URL="https://github.com/VonHeikemen/nvim-starter/tree/05-modular"
      CF_CAT="Starter"
      ;;
    2k)
      GH_URL="https://github.com/2KAbhishek/nvim2k"
      CF_CAT="Starter"
      ;;
    AstroNvimStart)
      GH_URL="https://github.com/doctorfree/AstroNvimStart"
      CF_CAT="Starter"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    Basic)
      GH_URL="https://github.com/NvChad/basic-config"
      CF_CAT="Starter"
      ;;
    CodeArt)
      GH_URL="https://github.com/artart222/CodeArt"
      NC_URL="http://neovimcraft.com/plugin/artart222/CodeArt"
      DF_URL="https://dotfyle.com/plugins/artart222/CodeArt"
      CF_CAT="Starter"
      PL_MAN="Packer"
      ;;
    Cosmic)
      GH_URL="https://github.com/CosmicNvim/CosmicNvim"
      NC_URL="http://neovimcraft.com/plugin/CosmicNvim/CosmicNvim"
      DF_URL="https://dotfyle.com/plugins/CosmicNvim/CosmicNvim"
      CF_CAT="Starter"
      ;;
    Ember)
      GH_URL="https://github.com/danlikestocode/embervim"
      DF_URL="https://dotfyle.com/danlikestocode/embervim-nvim"
      CF_CAT="Starter"
      ;;
    Fennel)
      GH_URL="https://github.com/jhchabran/nvim-config"
      CF_CAT="Starter"
      PL_MAN="Packer"
      ;;
    HardHacker)
      GH_URL="https://github.com/hardhackerlabs/oh-my-nvim"
      CF_CAT="Starter"
      ;;
    JustinLvim)
      GH_URL="https://github.com/justinsgithub/dotfiles"
      CF_CAT="Starter"
      CF_TYP="[LunarVim](https://www.lunarvim.org)"
      ;;
    JustinNvim)
      GH_URL="https://github.com/justinsgithub/dotfiles"
      CF_CAT="Starter"
      CF_TYP="[LazyVim](https://lazyvim.github.io)"
      ;;
    Kabin)
      GH_URL="https://github.com/kabinspace/AstroNvim_user"
      CF_CAT="Starter"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    Kickstart)
      GH_URL="https://github.com/doctorfree/kickstart.nvim"
      CF_CAT="Starter"
      CF_TYP="[Kickstart](https://github.com/nvim-lua/kickstart.nvim)"
      ;;
    Lamia)
      GH_URL="https://github.com/A-Lamia/AstroNvim-conf"
      CF_CAT="Starter"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    Micah)
      GH_URL="https://code.mehalter.com/AstroNvim_user"
      CF_CAT="Starter"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    Normal)
      GH_URL="https://github.com/NormalNvim/NormalNvim"
      NC_URL="http://neovimcraft.com/plugin/NormalNvim/NormalNvim"
      CF_CAT="Starter"
      CF_TYP="[AstroNvim](https://astronvim.com)"
      ;;
    NvPak)
      GH_URL="https://github.com/Pakrohk-DotFiles/NvPak.git"
      NC_URL="http://neovimcraft.com/plugin/Pakrohk-DotFiles/NvPak"
      CF_CAT="Starter"
      ;;
    Modern)
      GH_URL="https://github.com/alpha2phi/modern-neovim"
      CF_CAT="Starter"
      ;;
    pde)
      GH_URL="https://github.com/alpha2phi/neovim-pde"
      CF_CAT="Starter"
      ;;
    Rohit)
      GH_URL="https://github.com/rohit-kumar-j/nvim"
      CF_CAT="Starter"
      ;;
    Scratch)
      GH_URL="https://github.com/ngscheurich/nvim-from-scratch"
      CF_CAT="Starter"
      ;;
    SingleFile)
      GH_URL="https://github.com/creativenull/nvim-oneconfig"
      CF_CAT="Starter"
      PL_MAN="Packer"
      ;;
    *)
      echo "Unknown Lazyman configuration name: ${checkdir}"
      echo "Exiting"
      exit 1
      ;;
  esac

  echo "## ${nvimconf} Neovim Configuration Information" > "${OUTF}"
  echo "" >> "${OUTF}"
  echo "- Configuration category: \`${CF_CAT}\`" >> "${OUTF}"
  echo "- Base configuration:     \`${CF_TYP}\`" >> "${OUTF}"
  echo "- Plugin manager:         \`${PL_MAN}\`" >> "${OUTF}"
  echo "- Installation location:  \`~/.config/nvim-${nvimconf}\`" >> "${OUTF}"
  echo "" >> "${OUTF}"
  [ "${WS_URL}" ] && {
    echo "### Website" >> "${OUTF}"
    echo "" >> "${OUTF}"
    echo "[${WS_URL}](${WS_URL})" >> "${OUTF}"
    echo "" >> "${OUTF}"
  }
  [ "${GH_URL}" ] && {
    echo "### Github repository" >> "${OUTF}"
    echo "" >> "${OUTF}"
    echo "[${GH_URL}](${GH_URL})" >> "${OUTF}"
    echo "" >> "${OUTF}"
  }
  [ "${NC_URL}" ] && {
    echo "### Neovimcraft entry" >> "${OUTF}"
    echo "" >> "${OUTF}"
    echo "[${NC_URL}](${NC_URL})" >> "${OUTF}"
    echo "" >> "${OUTF}"
  }
  [ "${DF_URL}" ] && {
    echo "### Dotfyle entry" >> "${OUTF}"
    echo "" >> "${OUTF}"
    echo "[${DF_URL}](${DF_URL})" >> "${OUTF}"
    echo "" >> "${OUTF}"
  }
  get_plugins "${nvimconf}" "${OUTF}" "${PL_MAN}"
}

all=
while getopts "au" flag; do
    case $flag in
        a)
            all=1
            ;;
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

[ "${all}" ] && {
  for conf in ${CF_NAMES}
  do
    make_info ${conf}
  done
  exit 0
}

checkdir="nvim-Lazyman"
[ "$1" ] && checkdir="$1"
conf=$(echo "${checkdir}" | sed -e "s/^nvim-//")
make_info ${conf}
