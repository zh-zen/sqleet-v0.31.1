# sqleet Windows Build With Helper Scripts

这个项目来自原始的 [sqleet](https://github.com/resilar/sqleet) 项目。

当前仓库的用途不是继续维护上游源码说明，而是基于 `sqleet` 源码做一份
Windows 本地可直接使用的整理版本，主要包含两部分：

- 已编译好的 `sqleet.exe`
- 方便单文件和整文件夹批量处理的交互式脚本

## 项目来源

- 上游项目：`sqleet`
- 上游地址：[https://github.com/resilar/sqleet](https://github.com/resilar/sqleet)
- 本仓库保留了上游核心源码文件，例如 `sqleet.c`、`sqleet.h`、`shell.c`
- 本仓库额外完成了 Windows 下的编译，并补充了辅助脚本

## 当前目录中的主要内容

- `sqleet.exe`
  Windows 下可直接运行的 sqleet 命令行程序

- `sqleet.c` / `sqleet.h` / `shell.c`
  来自上游项目的核心源码

- `scripts/`
  本仓库新增的辅助脚本目录，用于交互式加密和解密数据库文件

## 已完成的内容

### 1. 编译出 Windows 可执行文件

本仓库已经基于上游源码编译出了：

```text
sqleet.exe
```

可以直接在 Windows 终端中使用，例如：

```bat
sqleet.exe :memory: "select sqlite_version();"
```

## 新增脚本功能

`scripts` 目录下新增了适合 Windows 使用的交互式脚本，专门用于数据库加密和解密。

### 单文件脚本

- `scripts\encrypt-db.bat`
  加密单个数据库文件

- `scripts\decrypt-db.bat`
  解密单个数据库文件

这两个脚本运行后会提示输入：

- 源文件路径
- 输出文件路径
- 密码

单文件模式不会修改原文件，而是生成目标文件。
如果输出路径留空：

- 单文件加密默认输出到源文件同目录下的 `encrypted` 子文件夹
- 单文件解密默认输出到源文件同目录下的 `decrypted` 子文件夹
- 输出文件名与原始文件名保持一致

### 文件夹批量脚本

- `scripts\encrypt-folder.bat`
  批量加密一个文件夹下所有 `.db` 文件

- `scripts\decrypt-folder.bat`
  批量解密一个文件夹下所有 `.db` 文件

这两个脚本运行后会提示输入：

- 文件夹路径
- 密码

## 批量处理命名规则

文件夹批量模式不再通过文件名后缀区分加密文件和解密文件。
输入文件本身不要求带特定名称后缀。

- 批量加密输出到当前目录下的 `encrypted` 子文件夹
- 批量解密输出到当前目录下的 `decrypted` 子文件夹
- 输出文件名与原始文件名保持一致

例如：

```text
data.db -> encrypted\data.db
data.db -> decrypted\data.db
```

## 脚本使用方式

可以双击运行，也可以在命令行中运行：

```bat
scripts\encrypt-db.bat
scripts\decrypt-db.bat
scripts\encrypt-folder.bat
scripts\decrypt-folder.bat
```

## 脚本行为说明

- 单文件模式下，输出文件如果已存在，会直接覆盖
- 原始源文件不会被修改
- 文件夹批量模式对源文件名称没有要求，只要是 `.db` 文件就会参与处理
- 文件夹批量模式下，如果对应的目标文件已经存在，则会自动跳过该源文件
- 文件夹批量模式只处理当前选中文件夹下直接存在的 `.db` 文件，不会进入 `encrypted` 或 `decrypted` 子文件夹

## 适用场景

这个仓库更适合以下用途：

- 在 Windows 上直接使用 sqleet
- 快速加密或解密 SQLite `.db` 文件
- 批量处理一个目录中的数据库文件
- 作为基于上游 `sqleet` 的本地整理版工程保存

## 上游说明

如果你需要查看 sqleet 原始项目的完整加密实现、API 说明、平台兼容性说明和版本信息，
请查看上游项目：

[https://github.com/resilar/sqleet](https://github.com/resilar/sqleet)
