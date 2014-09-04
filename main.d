/++
 main.d
#License
 Copyright (c) 2014- Seiji Fujita
 Distributed under the Boost Software License, Version 1.0.
++/

import std.stdio;
import debuglog;

void foo()
{
    outLog("Debuglog");
    outLog(1);
    outLog("2");
    outLog('3');
    outLog(4.0);
    outLog("5\n");
    outLog("foo/bar");
    outLog("wsting"w);
    outLog("dstring"d);
    
    //
    int d1 = 1;
    outLog("d1:", d1, "cooments...");
    
    string string1 = "string1234567890";
    outdumpLog(cast(void *)string1, string1.length, "string1 comments...");
    
    
    struct structS {
        char[20] c;
        int i;
        long l;
        double d;
    }
    structS ss;
    
    ss.c[0] = 'a';
    ss.c[1] = 'b';
    ss.c[2] = 'c';
    ss.i = 1;
    ss.l = 2;
    ss.d = 0.1;
    outdumpLog(cast(void *)&ss, ss.sizeof, "ss");
    
    string stringCode = "abc漢字def"c;
    outdumpLog(cast(void*)stringCode, stringCode.length, "utf8 string");
    
    wstring utf16Code = "abc漢字def"w;
    outdumpLog(cast(void*)utf16Code, utf16Code.length * wchar.sizeof, "utf16 string");
    
    dstring utf32Code = "abc漢字def"d;
    outdumpLog(cast(void*)utf32Code, utf32Code.length * dchar.sizeof, "utf32 string");
    
//    int int2 = 10;
//    outdumpLog2(utf32Code);
    

}

void checkTypes()
{
    string string1 = "string";
    int int1 = 1;
    uint uint1 = 2;
    short short1 = 3;
    ushort ushort1 = 4;
    long long1 = 5;
    ulong uloing1 = 6 ;
    char char1  = 'c';
    wchar wchar1 = 'c';
    dchar dchar1 = 'c';
    byte byte1 = 7;
    ubyte ubyte1 = 8;
    float floar1 = 9.1;
    double double1 = 9.2;
    wstring wstring1 = "wstring"w;
    dstring dstring1 = "dstring"d;

    outLog(string1, int1, uint1, short1, ushort1,
           long1, uloing1, char1, wchar1, dchar1,
           byte1, ubyte1, floar1, double1,
           wstring1, dstring1);

}

int main()
{
    int result = 0;
    try
    {
        setDebugLog();
        checkTypes();
        foo();
        writeln("done..");
    }
//	throw new Exception("");
    catch(Exception e)
    {
		outLog("Exception:", e.toString());
        writeln("Exception:", e.toString());
    	result = 1;
    }
    return result;
}


