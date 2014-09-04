##
##

#include config.dmd


TARGET  = debugLog.exe
OBJS    = debugLog.obj main.obj
#RES     = resource.res

####
## http://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html
CC      = gcc
CXX     = g++
CFLAGS  = -Wall -O2
CLDFLAGS =
CINCLUDES = -I/usr/local/include
CLIBS     = -L/usr/local/lib -lm

########
## http://dlang.org/dmd-windows.html
DMD     = dmd
####
DFLAGS = -wi -g
#DFLAGS = -g -version=Unicode
#DFLAGS  = -O -release -inline -noboundscheck -version=Unicode
#### LINK option http://msdn.microsoft.com/ja-jp/library/fcc1zstk.aspx
# x86:5.01 / x64: 5.02 / x86-x64: 6.00 / ARM: 6.02
DLDFLAGS =  -g -L/SUBSYSTEM:CONSOLE:5.01
#DLDFLAGS =  -g -L/SUBSYSTEM:WINDOWS:5.01
#DMDLIBS  = dmd_win32.lib
#DMDLIBS  = dmd_win32_debug.lib

####
## http://www.digitalmars.com/ctg/sc.html
DMC      = dmc
DMCFLAGS = -HP99 -g -o+none -D_WIN32_WINNT=0x0400 -I$(SETUPHDIR) $(CPPFLAGS)
DMCLIB   = lib
DMCLIBFLAGS = lib -p512 -c -n

DMD_LIB = lib

##---------------
# $@ : target
# $^ : depend target
# $< : top of target
# $* : without the suffix(ext) from the target
# $(MacroName:String=String2) : string replace
#

all : $(TARGET)

$(TARGET) : $(OBJS)
	$(DMD) $(OBJS) $(RES) $(DMDLIBS) $(DLDFLAGS) -of$@ 

test :
	$(TARGET)

clean :
	del *.obj
	del *.exe
	del *.bak
#	-rm -f $(TARGET) $(OBJS)

# MakeLib :

.c.obj :
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.d.obj :
	$(DMD) $(DFLAGS) -c $<

# Depend of header file
# obj : header
# foo.obj : foo.h 

