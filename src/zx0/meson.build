# ********************
# *** Source Files ***
# ********************

zx0_sources = files(
	'compress.c',
	'memory.c',
	'optimize.c'
)

# *****************
# *** All Files ***
# *****************

zx0_all_files = zx0_headers + zx0_sources

# ***************
# *** Library ***
# ***************

libzx0 = static_library(
	'zx0',
	zx0_all_files,
	
	include_directories: SEARCH_HEADER_DIR
)