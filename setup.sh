#!/bin/env bash

# install for ubuntu
. ./config

now_path=`pwd`

# var
lc='\033['
rc='\033[0m'
cred='31m'        # red
cgreen='32m'        # green

function check_user()
{
    now_user=`whoami`
    if [ ${now_user}X != ${username}X ]; then
        echo -e "Config user is ${lc}${cred}${username}${rc}, but your username is ${lc}${cred}${now_user}${rc}"
        exit -1
    fi
}

function show_help()
{
    echo -e "\n${lc}${cgreen}The following contents will to be done:${rc}\n"
    echo -e "1 Install Vundle(vim plugin) to ~/.vim/bundle/vundle/\n"
    echo -e "2 Copy config files to corresponding directory\n"
    echo -e "  including .aliascfg .gitconfig .vimrc .zshrc .tmux.conf\n"
    echo -e "3 Download some packages using apt-get\n"
    echo -e "4 Your username is ${lc}${cred}${username}${rc}\n"
}

function check_dir_vundle
{
    if [ -e "${HOME}/.vim/bundle/Vundle.vim/" ]; then
        echo -e "${lc}${cgreen}Vundle was already installed, setup will continue...${rc}"
    else
        echo -e "\nVundle is installing..."
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        echo "Start to install plugin by vundle..."
        vim +PluginInstall +qall
        echo -e "${lc}${cgreen}Install vundle success${rc}"
    fi
}

function copy_cfg_files
{
    echo ""
    # .aliascfg
    find ~ -maxdepth 1 -newer ".aliascfg" | grep "${HOME}/.aliascfg" &>/dev/null
    if [ -e ".aliascfg" -a $? != 0 ]; then
        cp -f .aliascfg ~/
        echo "cp -f .aliascfg ~/"
    fi

    # .gitconfig
    find ~ -maxdepth 1 -newer ".gitconfig" | grep "${HOME}/.gitconfig" &>/dev/null
    if [ -e ".gitconfig" -a $? != 0 ]; then
        cp -f .gitconfig ~/
        echo "cp -f .gitconfig ~/"
    fi

    # .vimrc
    find ~ -maxdepth 1 -newer ".vimrc" | grep "${HOME}/.vimrc" &>/dev/null
    if [ -e ".vimrc" -a $? != 0 ]; then
        cp -f .vimrc ~/
        echo "cp -f .vimrc ~/"
    fi

    # .zshrc
    find ~ -maxdepth 1 -newer ".zshrc" | grep "${HOME}/.zshrc" &>/dev/null
    if [ -e ".zshrc" -a $? != 0 ]; then
        cp -f .zshrc ~/
        echo "cp -f .zshrc ~/"
    fi
    cat ~/.zshrc | grep "aliascfg" > /dev/null
    if [ $? != 0 ]; then
        cp -f .zshrc ~/
        echo "cp -f .zshrc ~/"
    fi

    # .tmux.conf
    find ~ -maxdepth 1 -newer ".tmux.conf" | grep "${HOME}/.tmux.conf" &>/dev/null
    if [ -e ".tmux.conf" -a $? != 0 ]; then
        cp -f .tmux.conf ~/
        echo "cp -f .tmux.conf ~/"
    fi
    echo -e "${lc}${cgreen}Copy config files down${rc}"
}

function add_include_to_bash_profile
{
    echo -e "\nCheck if .bash_profile including .aliascfg..."
    grep "~/.aliascfg" ~/.bash_profile &>/dev/null
    if [ $? != 0 ]; then
        echo -e "\n# Include files\nif [ -f ~/.aliascfg ]; then\n    . ~/.aliascfg\nfi" >> ~/.bash_profile
        echo -e "${lc}${cgreen}File .bash_profile doesn't include .aliascfg, add it success${rc}"
    else
        echo ".aliascfg is already included"
    fi

    source ~/.bash_profile
}

function install_package
{
    # ctags
    echo "check ctags..."
    which ctags &> /dev/null
    if [ $? -ne 0 ]; then
        echo "ctags is not found, to install..."
        sudo apt-get install -y ctags 
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install ctags failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install ctags success${rc}"
    fi
    # zsh
    echo "check zsh..."
    which zsh &> /dev/null
    if [ $? -ne 0 ]; then
        echo "zsh is not found, to install..."
        sudo apt-get install -y zsh
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install zsh failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install zsh success${rc}"
    fi
    # autojump-zsh
    echo "check autojump-zsh..."
    rpm -qa|grep autojump-zsh >/dev/null
    if [ $? -ne 0 ]; then
        echo "autojump-zsh is not found, to install..."
        sudo apt-get install -y autojump
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install autojump-zsh failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install autojump-zsh success${rc}"
    fi
    # tmux
    echo "check tmux..."
    which tmux &> /dev/null
    if [ $? -ne 0 ]; then
        echo "tmux is not found, to install..."
        sudo apt-get install -y tmux
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install tmux failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install tmux success${rc}"
    fi
    # tree
    echo "check tree..."
    which tree &> /dev/null
    if [ $? -ne 0 ]; then
        echo "tree is not found, to install..."
        sudo apt-get install -y tree
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install tree failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install tree success${rc}"
    fi
    # wget
    echo "check wget..."
    which wget &> /dev/null
    if [ $? -ne 0 ]; then
        echo "wget is not found, to install..."
        sudo apt-get install -y wget
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install wget failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install wget success${rc}"
    fi
    # ag(the_silver_searcher)
    echo "check ag(the_silver_searcher)..."
    which ag &> /dev/null
    if [ $? -ne 0 ]; then
        echo "ag(the_silver_searcher) is not found, to install..."
        sudo apt-get install -y silversearcher-ag
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Install ag failed${rc}"
            exit -1
        fi
        echo -e "${lc}${cgreen}Install ag success${rc}"
    fi
}

function create_dir()
{
    # golang directory
    if [ ! -d "${HOME}/go_projects/src" ]; then
        mkdir -p ${HOME}/go_projects/src
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}mkdir -p ${HOME}/go_projects/src failed${rc}"
        else
            echo -e "${lc}${cgreen}mkdir -p ${HOME}/go_projects/src success${rc}"
        fi
    fi
    # tmp
    if [ ! -d "${HOME}/tmp" ]; then
        mkdir -p ${HOME}/tmp
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}mkdir -p ${HOME}/tmp failed${rc}"
        else
            echo -e "${lc}${cgreen}mkdir -p ${HOME}/tmp success${rc}"
        fi
    fi
}

function download()
{
    # oh-my-zsh
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        echo 'start download oh-my-zsh...'
        wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
        echo -e "${lc}${cgreen}Download oh-my-zsh over${rc}"
    fi
    cd ${now_path}
    # tmux
    cd ${HOME}/local/packages
    if [ ! -d "${HOME}/local/packages/tmux2.6" ]; then
        echo 'start download tmux2.6...'
        wget --no-check-certificate https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
        if [ $? -ne 0 ]; then
            echo -e "${lc}${cred}Download tmux failed${rc}"
            exit -1
        else
            echo -e "${lc}${cgreen}Download tmux success${rc}"
        fi
        tar -zxvf ./tmux-2.6.tar.gz
        cd ./tmux-2.6
        ./configure && make
        sudo make install
        rm -f ./tmux-2.6.tar.gz
    fi
    # tmux plugin tpm
    if [ ! -d "$${HOME}/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}


function use_zsh()
{
    sudo chsh -s /bin/zsh ${username}
    # source ~/.zshrc
    echo -e "${lc}${cgreen}You need to relogin to use zsh${rc}"
}

check_user
show_help
echo -ne "Are you sure to start? Make sure you have the ${lc}${cred}sudo${rc} permissions ${lc}${cred}without password${rc}(Y/N)"
read m_start_flag

case ${m_start_flag} in
y|Y)
    # 通过apt-get安装所需的包
    install_package
    # 下载相关文件或项目
    download
    # 将配置文件放到指定目录下
    copy_cfg_files

    # 使用bash或者zsh执行不同的操作
    if [ "${use_shell}"X = "bash" ]; then
        add_include_to_bash_profile
    else
        use_zsh
    fi

    # vim相关
    check_dir_vundle

    echo "Setup over"
    ;;
n|N)
    exit 0
    ;;
*)
    echo -e "${lc}${cred}#### error: your input is incorrect${rc}\n"
    ;;
esac
