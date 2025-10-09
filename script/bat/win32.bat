cl.exe src\zx0\compress.c      /Ox /c -I include
cl.exe src\zx0\optimize.c      /Ox /c -I include
cl.exe src\zx0\memory.c        /Ox /c -I include

cl.exe rasm.c /Ox /DNOAPULTRA=1 /DDOS_WIN=1 optimize.obj compress.obj memory.obj