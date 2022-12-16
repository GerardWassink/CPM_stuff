@echo off
echo compiling C program %1.c for CP/M
zcc +cpm %1.c -o %1.com
