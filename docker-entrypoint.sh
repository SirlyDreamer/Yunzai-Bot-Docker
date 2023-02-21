#!/usr/bin/env bash

set +e

GreenBG="\\033[42;37m"
YellowBG="\\033[43;37m"
BlueBG="\\033[44;37m"
Font="\\033[0m"

Version="${BlueBG}[版本]${Font}"
Info="${GreenBG}[信息]${Font}"
Warn="${YellowBG}[提示]${Font}"

WORK_DIR="/app/Yunzai-Bot"
MIAO_PLUGIN_PATH="/app/Yunzai-Bot/plugins/miao-plugin"
XIAOYAO_CVS_PATH="/app/Yunzai-Bot/plugins/xiaoyao-cvs-plugin"
PY_PLUGIN_PATH="/app/Yunzai-Bot/plugins/py-plugin"
PYTHON_PLUGIN_PATH="/app/Yunzai-Bot/plugins/python-plugin"

if [[ ! -d "$HOME/.ovo" ]]; then
    mkdir ~/.ovo
fi

echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 Yunzai-Bot 更新 ${Font} \n ================ \n"

cd $WORK_DIR

if [[ -z $(git status -s) ]]; then
    echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
    git add .
    git stash
    git pull origin master --allow-unrelated-histories --rebase
    git stash pop
else
    git pull origin master --allow-unrelated-histories
fi

if [[ ! -f "$HOME/.ovo/yunzai.ok" ]]; then
    set -e
    echo -e "\n ================ \n ${Info} ${GreenBG} 更新 Yunzai-Bot 运行依赖 ${Font} \n ================ \n"
    npm install
    touch ~/.ovo/yunzai.ok
    set +e
fi

echo -e "\n ================ \n ${Version} ${BlueBG} Yunzai-Bot 版本信息 ${Font} \n ================ \n"

git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

if [ -d $MIAO_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 喵喵插件 更新 ${Font} \n ================ \n"

    cd $MIAO_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin master --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin master --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/miao.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 喵喵插件 运行依赖 ${Font} \n ================ \n"
        npm install image-size
        touch ~/.ovo/miao.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} 喵喵插件版本信息 ${Font} \n ================ \n"
    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi

if [ -d $PYTHON_PLUGIN_PATH"/.git" ]; then

    cd $PYTHON_PLUGIN_PATH

    if [[ ! -f "$HOME/.ovo/python.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新Python运行依赖 ${Font} \n ================ \n"
        pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple -r $PYTHON_PLUGIN_PATH"/requirement.txt"
        touch ~/.ovo/python.ok
        set +e
    fi
    
    if [ ! -d $XIAOYAO_CVS_PATH ]; then  
        echo -e "\n ${Warn} ${YellowBG} 由于Python插件依赖xiaoyao-cvs-plugin，检测到目前没有安装，开始自动下载 ${Font} \n"
        git clone https://gitee.com/Ctrlcvs/xiaoyao-cvs-plugin.git $XIAOYAO_CVS_PATH"/"
    fi
fi

if [ -d $PY_PLUGIN_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 py-plugin 插件更新 ${Font} \n ================ \n"

    cd $PY_PLUGIN_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin main --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin main --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/py.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 py-plugin 运行依赖 ${Font} \n ================ \n"
        npm install iconv-lite @grpc/grpc-js @grpc/proto-loader
        poetry config virtualenvs.in-project true
        poetry install
        touch ~/.ovo/py.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} py-plugin 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"

fi

if [ -d $XIAOYAO_CVS_PATH"/.git" ]; then

    echo -e "\n ================ \n ${Info} ${GreenBG} 拉取 xiaoyao-cvs 插件更新 ${Font} \n ================ \n"

    cd $XIAOYAO_CVS_PATH

    if [[ -n $(git status -s) ]]; then
        echo -e " ${Warn} ${YellowBG} 当前工作区有修改，尝试暂存后更新。${Font}"
        git add .
        git stash
        git pull origin master --allow-unrelated-histories --rebase
        git stash pop
    else
        git pull origin master --allow-unrelated-histories
    fi

    if [[ ! -f "$HOME/.ovo/xiaoyao.ok" ]]; then
        set -e
        echo -e "\n ================ \n ${Info} ${GreenBG} 更新 xiaoyao-cvs 插件运行依赖 ${Font} \n ================ \n"
        npm install yaml promise-retry superagent
        touch ~/.ovo/xiaoyao.ok
        set +e
    fi

    echo -e "\n ================ \n ${Version} ${BlueBG} xiaoyao-cvs 插件版本信息 ${Font} \n ================ \n"

    git log -1 --pretty=format:"%h - %an, %ar (%cd) : %s"
fi

set -e

cd $WORK_DIR

echo -e "\n ================ \n ${Info} ${GreenBG} 启动 Yunzai-Bot ${Font} \n ================ \n"

node app
