# *****************
# *** Set shell ***
# *****************

ifeq ($(OS), Windows_NT)
SHELL := powershell.exe
else
SHELL := /bin/sh
endif