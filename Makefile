# ========================
# === Default Settings ===
# ========================
TARGET ?= none

# ============================
# === Target-Specific Rules ===
# ============================
ifeq ($(TARGET),windows)

	include mak/windows_nt.mak

else ifeq ($(TARGET),linux)

	include mak/linux.mak

else ifeq ($(TARGET),darwin)

	include mak/darwin.mak

else ifeq ($(TARGET),morphos)

	include mak/morphos.mak

else ifeq ($(TARGET),DOS)
	
	include mak/dos.mak

else ifeq ($(TARGET),none)

error:
	@echo "No target system specified. Use TARGET=Linux/Windows_NT/Darwin/MorphOS/DOS"

endif