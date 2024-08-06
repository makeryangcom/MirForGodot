# Mir2ForGodot

⚡ Mir2(2D MMORPG Game) For Godot ⚡

### Environment

> Godot 4.3、NodeJS 20.14.0、Python 3.10.10、Golang 1.22.0、VS2019

### Install

> On Centos Install Godot Server

### Godot Builds

> Compile private production environment editor and export template, compile platform Ubuntu 18.04, Windows11

#### 一、PCK Keygen

```shell
passphrase=makeryang@com
salt=00818CB5BBC4E346
key=B2B8A15FE5962BB6CCEB8D8634E9163561B0D5D62C24ECD0BA5C1EEC61648271
iv =62D1DE9D0C3B74CD8C1238E934804C1D
```

#### 二、Install&Update

```shell
sudo apt upgrade && sudo apt update
sudo apt install -y curl wget git vim openssh-server net-tools
sudo apt-get install -y build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev libwayland-dev
```

Update SCons

```shell
sudo apt remove scons
sudo apt install python3-pip
python3 -m pip install scons -i https://pypi.tuna.tsinghua.edu.cn/simple
python3 -m pip install scons
```

Update GCC

```shell
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 g++-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
```

#### 三、Build

Set the private key required for encryption

```shell
# Windows
set SCRIPT_AES256_ENCRYPTION_KEY=B2B8A15FE5962BB6CCEB8D8634E9163561B0D5D62C24ECD0BA5C1EEC61648271
# Linux
export SCRIPT_AES256_ENCRYPTION_KEY="B2B8A15FE5962BB6CCEB8D8634E9163561B0D5D62C24ECD0BA5C1EEC61648271"
```

Modify the following program in line 311 of modules/multiplayer/scene_multilayer.cpp

```shell
// ERR_FAIL_COND(peer > 0 && !connected_peers.has(peer));
if(peer > 0 && !connected_peers.has(peer)){
    return;
}
```

```shell
scons -j6 platform=windows production=yes
```

Build Export Templates

```shell
# Windows
scons platform=windows target=template_debug arch=x86_64
scons platform=windows target=template_release arch=x86_64
```

```shell
# Linux
/home/build/.local/bin/scons platform=linuxbsd target=template_debug arch=x86_64
/home/build/.local/bin/scons platform=linuxbsd target=template_release arch=x86_64
```
