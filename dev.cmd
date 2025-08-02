@echo off
echo 正在重新编译项目...
call npm run build
if %errorlevel% neq 0 (
    echo 编译失败，请检查错误信息
    pause
    exit /b 1
)

echo 编译完成，正在启动开发服务器...
call npm run dev -- --qrcode
pause 