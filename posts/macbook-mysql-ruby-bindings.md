Trouble installing mysql bindings on a MacBook?
---
<p>Twice now I have had this problem while building native mysql bindings on my MacBook. I'm running OSX 10.4.8 and I can't remember which version of the xcode tools.
</p><p>
 When you try and compile your bindings you will get an error message saying something like "ulong is undefined". The first time I got it was building the ruby mysql lib and I got it again this weekend building the perl dbi::mysql package.
</p><p>
 The quickest workaround is to just do a quick search of the source file that threw the error - in the case with ruby it was mysql.c somewhere deep in my gems directory. Find the header file, mysql.h in this case, and insert the line
</p><code>
#define ulong unsigned long
</code>
<p>
That did the trick in both cases. I'm glad I remembered it from the last time I saw it, I don't have the internet at home and had to get some Perl work done - CPAN is very very difficult to work with on just a few flying visits to cafes with wifi.
</p>
