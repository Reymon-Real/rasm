# ********************
# *** Source Files ***
# ********************

apultra_sources = files(
	'apultra.c',
	'expand.c',
	'matchfinder.c',
	'shrink.c'
)

# *****************
# *** All Files ***
# *****************

apultra_all_files = apultra_headers + apultra_sources

# ***************
# *** Library ***
# ***************

libapultra = static_library(
	'apultra',
	apultra_all_files,

	include_directories: SEARCH_HEADER_DIR
)