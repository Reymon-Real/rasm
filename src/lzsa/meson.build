# ********************
# *** Source Files ***
# ********************

lzsa_sources = files(
	'dictionary.c',
	'expand_block_v1.c',
	'expand_block_v2.c',
	'expand_context.c',
	'expand_inmem.c',
	'expand_streaming.c',
	'frame.c',
	'lzsa.c',
	'matchfinder.c',
	'shrink_block_v1.c',
	'shrink_block_v2.c',
	'shrink_context.c',
	'shrink_inmem.c',
	'shrink_streaming.c',
	'stream.c'
)

# *****************
# *** All Files ***
# *****************

lzsa_all_files = lzsa_headers + lzsa_sources

# ***************
# *** Library ***
# ***************

liblzsa = static_library(
	'lzsa',
	lzsa_all_files,

	include_directories: SEARCH_HEADER_DIR
)