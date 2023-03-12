#!/bin/bash
#
# lazyman - install and initialize Lazy Neovim configurations
#
# Written by Ronald Record <ronaldrecord@gmail.com>
#

usage() {
  printf "\nUsage: lazyman [-a] [-b branch] [-l] [-m] [-n] [-P] [-q]"
  printf "\n               [-rR] [-U url] [-N nvimdir] [-y] [-u]"
  printf "\nWhere:"
  printf "\n\t-a indicates install all supported Neovim configurations"
  printf "\n\t-b 'branch' specifies an nvim-lazyman git branch to checkout"
  printf "\n\t-l indicates install and initialize LazyVim"
  printf "\n\t-m indicates install and initialize nvim-multi"
  printf "\n\t-n indicates dry run, don't actually do anything, just printf's"
  printf "\n\t-p indicates use Packer rather than Lazy to initialize"
  printf "\n\t-q indicates quiet install"
  printf "\n\t-r indicates remove the previously installed configuration"
  printf "\n\t-R indicates remove previously installed configuration and backups"
  printf "\n\t-U 'url' specifies a URL to a Neovim configuration git repository"
  printf "\n\t-N 'nvimdir' specifies the folder name to use for the config given by -U"
  printf "\n\t-y indicates do not prompt, answer 'yes' to any prompt"
  printf "\n\t-u displays this usage message and exits"
  printf "\nWithout arguments install and initialize nvim-lazyman\n\n"
  exit 1
}

create_backups() {
  ndir="$1"
  [ -d $HOME/.config/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Backing up existing ${ndir} config as $HOME/.config/${ndir}-bak$$"
    }
    [ "${tellme}" ] || {
      mv $HOME/.config/${ndir} $HOME/.config/${ndir}-bak$$
    }
  }

  [ -d $HOME/.local/share/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Backing up existing ${ndir} plugins as $HOME/.local/share/${ndir}-bak$$"
    }
    [ "${tellme}" ] || {
      mv $HOME/.local/share/${ndir} $HOME/.local/share/${ndir}-bak$$
    }
  }

  [ -d $HOME/.local/state/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Backing up existing ${ndir} state as $HOME/.local/state/${ndir}-bak$$"
    }
    [ "${tellme}" ] || {
      mv $HOME/.local/state/${ndir} $HOME/.local/state/${ndir}-bak$$
    }
  }
  [ -d $HOME/.cache/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Backing up existing ${ndir} cache as $HOME/.cache/${ndir}-bak$$"
    }
    [ "${tellme}" ] || {
      mv $HOME/.cache/${ndir} $HOME/.cache/${ndir}-bak$$
    }
  }
}

remove_config() {
  ndir="$1"
  [ "${proceed}" ] || {
    printf "\nYou have requested removal of the Neovim configuration at:"
    printf "\n\t$HOME/.config/${ndir}\n"
    printf "\nConfirm removal of the Neovim ${ndir} configuration\n"
    while true
    do
      read -p "Remove ${ndir} ? (y/n) " yn
      case $yn in
        [Yy]* )
            break
            ;;
        [Nn]* )
            echo "Aborting removal and exiting"
            exit 0
            ;;
          * ) echo "Please answer yes or no."
            ;;
      esac
    done
  }

  [ -d $HOME/.config/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Removing existing ${ndir} config at $HOME/.config/${ndir}"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.config/${ndir}
    }
  }
  [ "${removeall}" ] && {
    [ "${quiet}" ] || {
      echo "Removing any ${ndir} config backups"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.config/${ndir}-bak*
    }
  }

  [ -d $HOME/.local/share/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Removing existing ${ndir} plugins at $HOME/.local/share/${ndir}"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.local/share/${ndir}
    }
  }
  [ "${removeall}" ] && {
    [ "${quiet}" ] || {
      echo "Removing any ${ndir} plugins backups"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.local/share/${ndir}-bak*
    }
  }

  [ -d $HOME/.local/state/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Removing existing ${ndir} state at $HOME/.local/state/${ndir}"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.local/state/${ndir}
    }
  }
  [ "${removeall}" ] && {
    [ "${quiet}" ] || {
      echo "Removing any ${ndir} state backups"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.local/state/${ndir}-bak*
    }
  }

  [ -d $HOME/.cache/${ndir} ] && {
    [ "${quiet}" ] || {
      echo "Removing existing ${ndir} cache at $HOME/.cache/${ndir}"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.cache/${ndir}
    }
  }
  [ "${removeall}" ] && {
    [ "${quiet}" ] || {
      echo "Removing any ${ndir} cache backups"
    }
    [ "${tellme}" ] || {
      rm -rf $HOME/.cache/${ndir}-bak*
    }
  }
}

set_brew() {
  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]
  then
    HOMEBREW_HOME="/home/linuxbrew/.linuxbrew"
  else
    if [ -x /usr/local/bin/brew ]
    then
      HOMEBREW_HOME="/usr/local"
    else
      if [ -x /opt/homebrew/bin/brew ]
      then
        HOMEBREW_HOME="/opt/homebrew"
      else
        printf "\nHomebrew brew executable could not be located\n"
        usage
      fi
    fi
  fi
  BREW_EXE="${HOMEBREW_HOME}/bin/brew"
}

all=
branch=
debug=
tellme=
lazyvim=
multivim=
packer=
proceed=
quiet=
remove=
removeall=
url=
name=
lazymandir="nvim-lazyman"
lazyvimdir="nvim-LazyVim"
multidir="nvim-multi"
nvimdir="${lazymandir}"
while getopts "ab:dlmnPqrRU:N:yu" flag; do
    case $flag in
        a)
            all=1
            lazyvim=1
            multivim=1
            nvimdir="${lazymandir} ${lazyvimdir} ${multidir}"
            ;;
        b)
            branch="${OPTARG}"
            ;;
        d)
            debug="-d"
            ;;
        l)
            lazyvim=1
            nvimdir="${lazyvimdir}"
            ;;
        m)
            multivim=1
            nvimdir="${multidir}"
            ;;
        n)
            tellme=1
            ;;
        P)
            packer=1
            ;;
        q)
            quiet=1
            ;;
        r)
            remove=1
            ;;
        R)
            remove=1
            removeall=1
            ;;
        U)
            url="${OPTARG}"
            ;;
        N)
            name="${OPTARG}"
            ;;
        y)
            proceed=1
            ;;
        u)
            usage
            ;;
    esac
done

[ "${name}" ] && nvimdir="${name}"
[ "${url}" ] && {
  [ "${name}" ] || {
    echo "ERROR: '-U url' must be accompanied with '-N nvimdir'"
    usage
  }
}

[ "${nvimdir}" ] || {
  echo "Something went wrong, nvimdir not set. Exiting."
  usage
}

[ "${remove}" ] && {
  for neovim in ${nvimdir}
  do
    remove_config ${neovim}
  done
  exit 0
}

[ "${all}" ] && {
    [ "${url}" ] || [ "${lazyvim}" ] || [ "${multivim}" ] && {
    echo "The -a option (all configs) cannot be used in conjunction with -U, -l, or -m"
    usage
  }
}

have_git=$(type -p git)
[ "${have_git}" ] || {
  echo "Install script requires git but git not found"
  echo "Please install git and retry this install script"
  usage
}

if [ -d $HOME/.config/${lazymandir} ]
then
  git -C $HOME/.config/${lazymandir} pull > /dev/null 2>&1
  [ "${branch}" ] && {
    git -C $HOME/.config/${lazymandir} checkout ${branch} > /dev/null 2>&1
  }
else
  [ "${quiet}" ] || {
    printf "\nCloning nvim-lazyman configuration into $HOME/.config/${lazymandir} ... "
  }
  [ "${tellme}" ] || {
    git clone \
      https://github.com/doctorfree/nvim-lazyman $HOME/.config/${lazymandir} > /dev/null 2>&1
    [ "${branch}" ] && {
      git -C $HOME/.config/${lazymandir} checkout ${branch} > /dev/null 2>&1
    }
  }
  [ "${quiet}" ] || printf "done"
fi

have_nvim=$(type -p nvim)
[ "${have_nvim}" ] || {
  [ "${quiet}" ] || {
    printf "\nInstall script requires neovim but nvim not found\n"
  }
  if [ -x ${HOME}/.config/${lazymandir}/scripts/install_neovim.sh ]
  then
    ${HOME}/.config/${lazymandir}/scripts/install_neovim.sh ${debug}
    BREW_EXE=
    set_brew
    [ -x ${BREW_EXE} ] || {
      echo "Homebrew brew executable not in PATH"
      usage
    }
    eval "$(${BREW_EXE} shellenv)"
    have_nvim=$(type -p nvim)
    [ "${have_nvim}" ] || {
      echo "Still cannot find neovim even after Homebrew install"
      echo "Something went wrong, install neovim and retry this install script"
      usage
    }
  else
    echo "Please install neovim and retry this install script"
    usage
  fi
}

nvim_version=$(nvim --version | head -1 | grep -o '[0-9]\.[0-9]')

if (( $(echo "$nvim_version < 0.9 " |bc -l) )); then
  [ "${all}" ] && {
    echo "Installation of all supported Neovim configurations is not supported"
    echo "with Neovim version less than 0.9. Exiting without installing."
    usage
  }
  [ "${quiet}" ] || {
    echo "Detected Neovim version ${nvim_version} does not support the"
    echo "NVIM_APPNAME environment variable. To utilize the full functionality"
    echo "of the lazyman Lazy Neovim Manager, upgrade to Neovim 0.9 or later."
  }
  have_appname=
  nvimdir="nvim"
else
  have_appname=1
fi
[ "${have_appname}" ] || {
  [ "${lazyvim}" ] || [ "${multivim}" ] || {
    ln -s ${HOME}/.config/${lazymandir} ${HOME}/.config/nvim
  }
}

for neovim in ${nvimdir}
do
  [ "${neovim}" == "${lazymandir}" ] && continue
  create_backups ${neovim}
done

[ "${lazyvim}" ] && {
  [ "${quiet}" ] || {
    printf "\nCloning LazyVim starter configuration into $HOME/.config/${lazyvimdir} ... "
  }
  [ "${tellme}" ] || {
    git clone \
      https://github.com/LazyVim/starter $HOME/.config/${lazyvimdir} > /dev/null 2>&1
    [ "${have_appname}" ] || ln -s ${HOME}/.config/${lazyvimdir} ${HOME}/.config/nvim
  }
  [ "${quiet}" ] || printf "done"
}
[ "${multivim}" ] && {
  [ "${quiet}" ] || {
    printf "\nCloning nvim-multi configuration into $HOME/.config/${multidir} ... "
  }
  [ "${tellme}" ] || {
    git clone \
      https://github.com/doctorfree/nvim-multi $HOME/.config/${multidir} > /dev/null 2>&1
    [ "${have_appname}" ] || ln -s ${HOME}/.config/${multidir} ${HOME}/.config/nvim
  }
  [ "${quiet}" ] || printf "done"
}
[ "${url}" ] && {
  [ "${quiet}" ] || {
    printf "\nCloning ${url} into $HOME/.config/${nvimdir} ... "
  }
  [ "${tellme}" ] || {
    git clone \
      ${url} $HOME/.config/${nvimdir} > /dev/null 2>&1
    [ "${have_appname}" ] || ln -s ${HOME}/.config/${nvimdir} ${HOME}/.config/nvim
  }
  [ "${quiet}" ] || printf "done"
}

[ "${packer}" ] && {
  PACKER="$HOME/.local/share/${nvimdir}/site/pack/packer/start/packer.nvim"
  [ -d "${PACKER}" ] || {
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "${PACKER}"
  }
}

currlimit=$(ulimit -n)
hardlimit=$(ulimit -Hn)
if [ ${hardlimit} -gt 4096 ]
then
  [ "${tellme}" ] || ulimit -n 4096
else
  [ "${tellme}" ] || ulimit -n ${hardlimit}
fi

for neovim in ${nvimdir}
do
  [ "${quiet}" ] || {
    printf "\nInitializing newly installed ${neovim} Neovim configuration ... "
  }
  export NVIM_APPNAME="${neovim}"
  [ "${tellme}" ] || {
    if [ "${debug}" ]
    then
      if [ "${packer}" ]
      then
        nvim --headless "+PackerSync" +qa
        nvim --headless "+PackerInstall" +qa
      else
        nvim --headless "+Lazy! sync" +qa
        nvim --headless "+Lazy! update" +qa
        nvim --headless "+Lazy! install" +qa
      fi
    else
      if [ "${packer}" ]
      then
        nvim --headless "+PackerSync" +qa > /dev/null 2>&1
        nvim --headless "+PackerInstall" +qa > /dev/null 2>&1
      else
        nvim --headless "+Lazy! sync" +qa > /dev/null 2>&1
        nvim --headless "+Lazy! update" +qa > /dev/null 2>&1
        nvim --headless "+Lazy! install" +qa > /dev/null 2>&1
      fi
    fi
    # nvim -c "checkhealth" -c 'qa' > /dev/null 2>&1
  }
  [ "${quiet}" ] || {
    printf "done\n"
  }
done

[ "${quiet}" ] || {
  echo "Installing lazyman command in $HOME/.local/bin"
}
[ "${tellme}" ] || {
  [ -d $HOME/.local/bin ] || mkdir -p $HOME/.local/bin
  [ -f $HOME/.config/nvim-lazyman/install.sh ] && {
    cp $HOME/.config/nvim-lazyman/install.sh $HOME/.local/bin/lazyman
    chmod 755 $HOME/.local/bin/lazyman
    [ "${quiet}" ] || {
      echo ""
      echo "Use $HOME/.local/bin/lazyman to explore Lazy Neovim configurations."
      echo "Review the lazyman usage message with:"
      printf "\n\t$HOME/.local/bin/lazyman -u\n"
    }
  }
}

[ "${tellme}" ] || ulimit -n ${currlimit}

[ "${nvimdir}" == "nvim" ] || {
  [ "${quiet}" ] || {
    printf "\nAdd the following line to your .bashrc or .zshrc shell initialization:"
    if [ "${lazyvim}" ]
    then
      printf '\n\texport NVIM_APPNAME="nvim-LazyVim"\n'
    elif [ "${multivim}" ]
    then
      printf '\n\texport NVIM_APPNAME="nvim-multi"\n'
    elif [ "${url}" ]
    then
      printf "\n\texport NVIM_APPNAME=\"${nvimdir}\"\n"
    else
      printf '\n\texport NVIM_APPNAME="nvim-lazyman"\n'
    fi
  }
}
echo ""

[ "${tellme}" ] || nvim
