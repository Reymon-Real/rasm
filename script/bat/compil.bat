set OBJ_DIR=build\objects\windows
set SRC_ZX0DIR=src\zx0
set SRC_APUDIR= src\apultra
set SRC_LZSADIR= src\lzsa
set CFLAGS=/O2 /Qpar /Ob3 /c -I include

cl %SRC_ZX0DIR%\compress.c		%CFLAGS% /Fo%OBJ_DIR%\zx0\compress.obj
cl %SRC_ZX0DIR%\optimize.c      %CFLAGS% /Fo%OBJ_DIR%\zx0\optimize.obj
cl %SRC_ZX0DIR%\memory.c        %CFLAGS% /Fo%OBJ_DIR%\zx0\memory.obj

cl %SRC_APUDIR%\expand.c      %CFLAGS% /Fo%OBJ_DIR%\apultra\expand.obj
cl %SRC_APUDIR%\matchfinder.c %CFLAGS% /Fo%OBJ_DIR%\apultra\matchfinder.obj
cl %SRC_APUDIR%\shrink.c      %CFLAGS% /Fo%OBJ_DIR%\apultra\shrink.obj

cl %SRC_APUDIR%\divsufsort.c       %CFLAGS% /Fo%OBJ_DIR%\apultra\divsufsort.obj
cl %SRC_APUDIR%\divsufsort_utils.c %CFLAGS% /Fo%OBJ_DIR%\apultra\divsufsort_utils.obj
cl %SRC_APUDIR%\sssort.c           %CFLAGS% /Fo%OBJ_DIR%\apultra\sssort.obj
cl %SRC_APUDIR%\trsort.c           %CFLAGS% /Fo%OBJ_DIR%\apultra\trsort.obj

cl %SRC_LZSADIR%\dictionary.c      %CFLAGS% /Fo%OBJ_DIR%\lzsa\dictionary.obj
cl %SRC_LZSADIR%\expand_block_v1.c %CFLAGS% /Fo%OBJ_DIR%\lzsa\expand_block_v1.obj
cl %SRC_LZSADIR%\expand_block_v2.c %CFLAGS% /Fo%OBJ_DIR%\lzsa\expand_block_v2.obj
cl %SRC_LZSADIR%\expand_context.c  %CFLAGS% /Fo%OBJ_DIR%\lzsa\expand_context.obj
cl %SRC_LZSADIR%\expand_inmem.c    %CFLAGS% /Fo%OBJ_DIR%\lzsa\expand_inmem.obj
cl %SRC_LZSADIR%\frame.c           %CFLAGS% /Fo%OBJ_DIR%\lzsa\frame.obj
cl %SRC_LZSADIR%\matchfinder.c     %CFLAGS% /Fo%OBJ_DIR%\lzsa\matchfinder.obj
cl %SRC_LZSADIR%\shrink_block_v1.c %CFLAGS% /Fo%OBJ_DIR%\lzsa\shrink_block_v1.obj
cl %SRC_LZSADIR%\shrink_block_v2.c %CFLAGS% /Fo%OBJ_DIR%\lzsa\shrink_block_v2.obj
cl %SRC_LZSADIR%\shrink_context.c  %CFLAGS% /Fo%OBJ_DIR%\lzsa\shrink_context.obj
cl %SRC_LZSADIR%\shrink_inmem.c    %CFLAGS% /Fo%OBJ_DIR%\lzsa\shrink_inmem.obj

cl src\rasm.c %CFLAGS% /Fo%OBJ_DIR%\rasm.obj

cl /O2 rasm.obj expand.obj matchfinder.obj shrink.obj dictionary.obj expand_block_v1.obj expand_block_v2.obj expand_context.obj expand_inmem.obj frame.obj matchfinder_lzsa.obj shrink_block_v1.obj shrink_block_v2.obj shrink_context.obj shrink_inmem.obj divsufsort.obj divsufsort_utils.obj sssort.obj trsort.obj optimize.obj compress.obj memory.obj

upx.exe --ultra-brute rasm.exe