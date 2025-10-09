project(
	'Roudoudou Assembler',
	'c',

	version: '2.3.10',
	meson_version: '>=1.8.0',

	license: 'Copyright (c) BERGE Edouard (roudoudou)',

	license_files: 'rasm_copyright.txt'
)

# ************************
# *** System Variables ***
# ************************

system = host_machine.system()

# *************************
# *** Project Variables ***
# *************************

version = meson.project_version()

# **************************
# *** Languages Settings ***
# **************************

#add_project_arguments(
#
#	'-DRASM_VERSION=' + version,
#
#	language: 'c'
#)

# *******************
# *** Directories ***
# *******************

SEARCH_HEADER_DIR = include_directories(
	'include',
	'include/zx0',
	'include/rasm',
	'include/lzsa',
	'include/apultra',
	'include/divsufsort',

	'src',
	'src/zx0',
	'src/rasm',
	'src/lzsa',
	'src/apultra',
	'src/divsufsort'
)

# *************
# *** Files ***
# *************

rasm = 'rasm'

zx0_headers = files(
	'include/zx0/zx0.h'
)

rasm_headers = files(
	'include/rasm/exomizer.h',
	'include/rasm/lz4.h',
	'include/rasm/minilib.h',
	'include/rasm/rasm.h',
	'include/rasm/zx7.h'
)

lzsa_headers = files(
	'include/lzsa/dictionary.h',
	'include/lzsa/expand_block_v1.h',
	'include/lzsa/expand_block_v2.h',
	'include/lzsa/expand_context.h',
	'include/lzsa/expand_inmem.h',
	'include/lzsa/expand_streaming.h',
	'include/lzsa/format.h',
	'include/lzsa/frame.h',
	'include/lzsa/lib.h',
	'include/lzsa/matchfinder.h',
	'include/lzsa/shrink_block_v1.h',
	'include/lzsa/shrink_block_v2.h',
	'include/lzsa/shrink_context.h',
	'include/lzsa/shrink_inmem.h',
	'include/lzsa/shrink_streaming.h',
	'include/lzsa/stream.h'
)

apultra_headers = files(
	'include/apultra/expand.h',
	'include/apultra/format.h',
	'include/apultra/libapultra.h',
	'include/apultra/matchfinder.h',
	'include/apultra/shrink.h'
)

divsufsort_headers = files(
	'include/divsufsort/divsufsort_config.h',
	'include/divsufsort/divsufsort.h',
	'include/divsufsort/divsufsort_private.h'
)

# ********************
# *** Dependencies ***
# ********************

# **********************
# *** Subdirectories ***
# **********************

subdir('src')

# *****************
# *** All files ***
# *****************

rasm_all_files = rasm_headers + rasm_sources

# ******************
# *** Executable ***
# ******************

if system == 'linux'

rasm_exec = executable(
	'rasm',
	rasm_all_files,

	link_with: [
		libzx0,
		liblzsa,
		libapultra,
		libdivsufsort
	],

	link_args: [
		'-lc',
		'-lm'
	],

	include_directories: SEARCH_HEADER_DIR,

	install: true
)

elif system == 'windows'

rasm_exec = executable(
	'rasm',
	rasm_all_files,

	link_with: [
		libzx0,
		liblzsa,
		libapultra,
		libdivsufsort
	],

	include_directories: SEARCH_HEADER_DIR,

	install: true
)

endif