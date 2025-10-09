# ********************
# *** Source Files ***
# ********************

divsufsort_sources = files(
	'divsufsort.c',
	'divsufsort_utils.c',
	'sssort.c',
	'trsort.c'
)

# *****************
# *** All Files ***
# *****************

divsufsort_all_files = divsufsort_headers + divsufsort_sources

# ***************
# *** Library ***
# ***************

libdivsufsort = static_library(
	'divsufsort',
	divsufsort_all_files,

	include_directories: SEARCH_HEADER_DIR
)