@echo off
:: 设置命令行编码为UTF-8
chcp 65001
setlocal enabledelayedexpansion

:: 定义颜色代码
set "GREEN=[32m"
set "RED=[31m"
set "RESET=[0m"

:: 定义安装目录
set "CURRENT_DIR=%cd%"
set "INSTALL_DIR=%CURRENT_DIR%\zookeeper"
set "DOWNLOAD_DIR=%CURRENT_DIR%\download"

echo ======================================
echo ZooKeeper安装程序
echo ======================================

:: 创建下载目录
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

:: 显示版本列表
echo 可用版本：
echo ---------------------------------------------------------------
echo 1. 3.4.14 (老稳定版)
echo    - 适合旧系统/基础功能稳定/最低Java要求：Java 6+
echo ---------------------------------------------------------------
echo 2. 3.5.9
echo    - 增加了动态重配置功能/ 改进的安全特性/更好的监控支持/要求Java 8+
echo ---------------------------------------------------------------
echo 3. 3.6.3
echo    - 新的通信协议/ SSL支持改进/监控功能增强/要求Java 8+
echo ---------------------------------------------------------------
echo 4. 3.7.1
echo    - 性能优化/更好的可观测性/安全性增强/要求Java 8+
echo ---------------------------------------------------------------
echo 5. 3.7.2
echo    - 3.7系列最新版本/Bug修复和稳定性改进/要求Java 8+
echo ---------------------------------------------------------------
echo 6. 3.8.0
echo    - 重要性能优化/新特性支持/要求Java 8+
echo ---------------------------------------------------------------
echo 7. 3.8.1 (推荐版本)
echo    - 最新稳定版本/包含所有最新特性和安全更新/适合新项目使用/要求Java 8+
echo ---------------------------------------------------------------
echo.
echo 版本选择建议：
echo  * 新项目推荐：选择 7 (3.8.1 最新稳定版)
echo  * 旧系统兼容：选择 1 (3.4.14)
echo  * 如果需要特定功能，请根据上述功能说明选择对应版本

:: 用户选择版本
set /p VERSION_CHOICE="请选择版本号(1-7): "

:: 根据选择设置下载URL和版本
if "%VERSION_CHOICE%"=="1" (
    set "VERSION=3.4.14"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="2" (
    set "VERSION=3.5.9"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.5.9/apache-zookeeper-3.5.9-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.5.9/apache-zookeeper-3.5.9-bin.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="3" (
    set "VERSION=3.6.3"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="4" (
    set "VERSION=3.7.1"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="5" (
    set "VERSION=3.7.2"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.7.2/apache-zookeeper-3.7.2-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.7.2/apache-zookeeper-3.7.2-bin.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="6" (
    set "VERSION=3.8.0"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz"
    )
) else if "%VERSION_CHOICE%"=="7" (
    set "VERSION=3.8.1"
    set "DOWNLOAD_URL=https://downloads.apache.org/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1-bin.tar.gz"
    if not exist "%ZIP_FILE%" (
        set "DOWNLOAD_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1-bin.tar.gz"
    )
) else (
    echo [错误] 无效的选择！
    pause
    exit /b 1
)

echo.
echo 您选择的版本是: ZooKeeper %VERSION%
echo 开始下载并安装...
echo.

:: 设置文件名
for %%F in ("%DOWNLOAD_URL%") do set "FILENAME=%%~nxF"
set "ZIP_FILE=%DOWNLOAD_DIR%\%FILENAME%"

:: 下载文件
echo [信息] 正在下载 ZooKeeper %VERSION%...
powershell -Command "& { $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%' }"

if not exist "%ZIP_FILE%" (
    echo [错误] 下载失败！
    pause
    exit /b 1
)

:: 解压文件
echo [信息] 正在解压文件...
tar -xzf "%ZIP_FILE%" -C "%CURRENT_DIR%"
if errorlevel 1 (
    echo [错误] 解压失败！
    pause
    exit /b 1
)

:: 确定解压后的目录名
if exist "%CURRENT_DIR%\zookeeper-%VERSION%" (
    set "EXTRACTED_DIR=zookeeper-%VERSION%"
) else if exist "%CURRENT_DIR%\apache-zookeeper-%VERSION%-bin" (
    set "EXTRACTED_DIR=apache-zookeeper-%VERSION%-bin"
)

:: 如果已存在安装目录，先删除
if exist "%INSTALL_DIR%" (
    echo [信息] 删除已存在的安装目录...
    rd /s /q "%INSTALL_DIR%"
)

:: 复制文件到安装目录
if exist "%CURRENT_DIR%\%EXTRACTED_DIR%" (
    echo [信息] 复制文件到安装目录...
    xcopy "%CURRENT_DIR%\%EXTRACTED_DIR%" "%INSTALL_DIR%" /E /I /H /Y
    rd /s /q "%CURRENT_DIR%\%EXTRACTED_DIR%"
)

:: 配置ZooKeeper
echo [信息] 配置ZooKeeper...
if not exist "%INSTALL_DIR%\conf\zoo_sample.cfg" (
    echo [错误] 未找到配置文件模板！
    pause
    exit /b 1
)

copy "%INSTALL_DIR%\conf\zoo_sample.cfg" "%INSTALL_DIR%\conf\zoo.cfg"
mkdir "%INSTALL_DIR%\data" 2>nul
mkdir "%INSTALL_DIR%\logs" 2>nul

:: 修改配置文件
powershell -Command "(gc '%INSTALL_DIR%\conf\zoo.cfg') -replace 'dataDir=.*', 'dataDir=%INSTALL_DIR:\=/%/data' | Set-Content '%INSTALL_DIR%\conf\zoo.cfg' -Encoding UTF8"
powershell -Command "(gc '%INSTALL_DIR%\conf\zoo.cfg') -replace 'dataLogDir=.*', 'dataLogDir=%INSTALL_DIR:\=/%/logs' | Set-Content '%INSTALL_DIR%\conf\zoo.cfg' -Encoding UTF8"

:: 启动ZooKeeper
echo [信息] 启动ZooKeeper服务...
cd /d "%INSTALL_DIR%\bin"
start zkServer.cmd

echo ======================================
echo ZooKeeper %VERSION% 安装完成！
echo.
echo 安装目录：%INSTALL_DIR%
echo 配置文件：%INSTALL_DIR%\conf\zoo.cfg
echo 数据目录：%INSTALL_DIR%\data
echo 日志目录：%INSTALL_DIR%\logs
echo.
echo 服务已启动，请检查服务状态...
echo ======================================

:: 清理下载文件
echo [信息] 是否删除下载的安装包？(Y/N)
set /p DELETE_CHOICE="请选择: "
if /i "%DELETE_CHOICE%"=="Y" (
    del /f /q "%ZIP_FILE%"
    echo [信息] 安装包已删除
)

echo.
echo 按任意键退出...
pause > nul