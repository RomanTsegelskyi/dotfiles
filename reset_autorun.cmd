reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun ^
  /t REG_EXPAND_SZ /d "C:\Users\romants\Code\dotfiles\cmd_autorun.cmd" /f
