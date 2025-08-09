# *******************************
# *** Function for find files ***
# *******************************

define FIND
$(wildcard $(1)/*.$(2)) \
$(wildcard $(1)/**/*.$(2)) \
$(wildcard $(1)/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/**/**/**/**/*.$(2)) \
$(wildcard $(1)/**/**/**/**/**/**/**/**/**/**/**/**/**/**/*.$(2))
endef

# ****************************************
# *** Functions for create directories ***
# ****************************************

ifeq ($(OS), Windows_NT)

define RM
$raw = $(1)
$files = $raw -split ' ' | ForEach-Object { '\"' + $_ + '\"' }
foreach ($file in $files) {
	Remove-Item -Path "$file" -Force -ErrorAction SilentlyContinue
}
endef

define MKDIR
New-Item -Type directory -Path "$(1)"
endef

else

define RM
rm -f $(1)
endef

define MKDIR
mkdir -p "$(1)"
endef

endif