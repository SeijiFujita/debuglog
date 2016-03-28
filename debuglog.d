/++++
debugLog.d

#License
Copyright (c) 2014- Seiji Fujita
Distributed under the Boost Software License, Version 1.0.
++++/
module debuglog;

import std.stdio;
import core.vararg;
import std.ascii: isPrintable;
import std.string: format, lastIndexOf;
import std.file: append;
import std.datetime;
//

version = useDebugLog;
// version = useAddDateExt;

static int LogFlag;
static string debugLogFilename;

/++
enum logStatus {
    NON,
    LogOnly,
    WithConsole
}
++/

void outLog(string file = __FILE__, int line = __LINE__, T...)(T t)
{
    version (useDebugLog) {
        _outLogV(format("%s:%d:[%s]", file, line, _getDateTimeStr()), t);
    }
}

// setDebugLog();
void setDebugLog(int flag = 1)
{
  version (useDebugLog) {
    string ext;
    version (useAddDateExt) {
        ext = "debug_log" ~ _getDateStr() ~ ".txt";
    } else {
        ext = "debug_log.txt";
    }
    debugLogFilename = ext;
    
    string logfilename;
    import core.runtime: Runtime;
    if (Runtime.args.length) {
        logfilename = Runtime.args[0];
    }
    if (logfilename.length) {
        int n = lastIndexOf(logfilename, ".");
        if ( n > 0 )
            debugLogFilename = logfilename[0 .. n]  ~ "." ~ ext;
        else
            debugLogFilename =  logfilename ~ "." ~ ext;
    }
    LogFlag = flag;
    outLog(format("==debuglog %s", debugLogFilename));
  }
}

void _outLog(lazy string dg)
{
    if (LogFlag) {
        append(debugLogFilename, dg());
    }
}

void _outLoglf(lazy string dg)
{
    if (LogFlag) {
        append(debugLogFilename, dg() ~ "\n");
    }
}

void _outLog2(lazy string dg1, lazy string dg2)
{
    if (LogFlag) {
        string  sout = dg1() ~ format("[%s]", _getDateTimeStr()) ~ dg2();
        append(debugLogFilename, sout ~ "\n");
        // writeln(debugLogFilename, sout);
        // stdout.writeln(sout);
    }
}

void _outLogV(A...)(A args) {
    import std.format : formattedWrite;
    import std.array : appender;
    auto w = appender!string();
    foreach (arg; args) {
        formattedWrite(w, "%s", arg);
    }
    _outLoglf(w.data);
}


string _getDateTimeStr()
{
    SysTime cTime = Clock.currTime();
    return format(
        "%04d/%02d/%02d-%02d:%02d:%02d",
        cTime.year,
        cTime.month,
        cTime.day,
        cTime.hour,
        cTime.minute,
        cTime.second);
}

static _getDateStr()
{
    SysTime cTime = Clock.currTime();
    return format(
        "%04d/%02d/%02d",
        cTime.year,
        cTime.month,
        cTime.day);
}
/++
outdumpLog(void *, uint, string);
outdumpLog(cast(void*)foo, foo.length, "string");
++/
void outdumpLog(string file = __FILE__, int line = __LINE__, T1, T2, T3)(T1 t1, T2 t2, T3 t3)
if (is(T1 == void*) && is(T2 == uint) && is(T3 == string))
{
    version (useDebugLog) {
        _outLoglf(format("%s:%d:[%s] %s, %d byte", file, line, _getDateTimeStr(), t3, t2));
        _dumpLog(t1, t2);
    }
}

/++
outdumpLog2(anytype, ...);
outdumpLog(cast(void*)foo, foo.length, "string");

void outdumpLog2(string file = __FILE__, int line = __LINE__, T...) (T t)
{
    format("%s:%d:[%s] ", file, line, _getDateTimeStr())._outLoglf();
    foreach (i, v; t) {
        if (i == 1) {
            void* ptr = cast(void*)v;
            uint size;
            if (typeid(x) == "string")
                size = v.length * char.sizeof;

            _dumpLog(ptr, size);

        } else {
            _outLogV(v);
        }
    }


}
++/

//
static void _dumpLog(void *Buff, uint byteSize)
{
    enum PrintLen = 16;
    ubyte[PrintLen] dumpBuff;

    void printCount(uint n) {
        _outLog(format("%06d: ", n));
    }
    void printBody() {
        string s;
        foreach (int i, ubyte v; dumpBuff) {
            if (i == PrintLen / 2) {
                s ~= " ";
            }
            s ~= format("%02X ", v);
        }
        _outLog(s);
    }
    void printAscii() {
        string s;
        char c;
        foreach (ubyte v; dumpBuff) {
            c = cast(char)v;
            if (! isPrintable(c))
                c = '.';
            s ~= format("%c", c);
        }
        _outLoglf(s);
    }
    // Main
    uint endPrint;
    for (uint i; i < byteSize + PrintLen; i += PrintLen) {
        endPrint = i + PrintLen;
        if (byteSize < endPrint) {
            uint end = byteSize - i;
            dumpBuff = dumpBuff.init;
            dumpBuff[0 .. end] = cast(ubyte[]) Buff[i .. byteSize];
            printCount(i);
            printBody();
            printAscii();
            break;
        }
        dumpBuff = cast(ubyte[]) Buff[i .. endPrint];
        printCount(i);
        printBody();
        printAscii();
    }
}
//eof
