@echo off

:: Stop the print spooler service
net stop spooler

:: Deletes all print files from the spooler
del %systemroot%\System32\spool\printers\* /Q

:: Starts the print spooler service
net start spooler