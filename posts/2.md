Performance increase in C# 2.0 using generics
---
<p>I've spent the past couple of days doing some fairly intense performance optimization at work. We have a C# implementation of a bayesian classifier that was written in the 1.1 version of the framework. Recently we've had a need to use it in a high volume situation and the performance wasn't quite up to scratch, the average time to classify was about 700ms. The past couple of days worth of benchmarking, profiling, testing, and tuning has gotten the run down to 30ms.</p>

<p>
Short version of the story: the bulk of the performance increases came from tweaking some string manipulation and... generics. Quite a unique C# performance story right there.
</p><p>
Most of the value we got out of generics was in the implementation of our  <a target="_blank" href="http://www.umiacs.umd.edu/~jhu/DOCS/SP/docs/essl/essl125.html">compressed sparse vector</a> implementation.
</p><p>
The original implementation was a thin-ish wrapper on a hashtable all designed to hold word - frequency counts. The compression is provided in this way:
</p>
<code>  public double this[string key]
{
get {
if (InnerHashtable.ContainsKey(key))
{ return (double)InnerHashtable[key] }
else { return 0.0d } }
set { InnerHashtable[key] = value; }
}</code>

<code> </code><p>When that code is run thousands and thousands of time all that boxing/unboxing becomes quite a hassle. I ended up refactoring the class to inherit from Dictionary which allowed me to removing all the casting there and also gave the chance to iterate over KeyValuePair&lt;string, double&gt; rather than the DictionaryEntry that I had to deal with before then.</p>
<p>
The other big perfomance gain was in moving from IComparer to IComparer&lt;T&gt;. The previous comparer I was dealing with was to compare the values (not the keys) stored in two dictionary entries. The old method had 4 casts, 2 to convert the "objects" being compared to DictionaryEntry references, then another 2 more to cast the DictionaryEntry values to doubles. That adds up to 5 lines of code, 4 of which are casts just to perform a simple comparison (of which you're doing thousands). I replaced this with a IComparer&lt;KeyValuePair&lt;string, double&gt;&gt; which left me with just one line, a very neat and tidy strongly typed comparison.
</p><p>
To me it seems generics can give some real performance benefits. I have read that null checks against T can be very, very expensive (I can't remember where sorry) so if your comparer has to included some null checks you might be better off sticking with a non generic implementation. When carrying out this kind of work the important thing to do is test, test, test, profile, and test. I got probably 40% of my performance boost just in tidying up string manipulation code that my profiler picked up. Big gains for very cheap work there.
</p><p>
For the profiling I was doing I used <a target="_blank" href="http://www.jetbrains.com/profiler/">dotTrace</a> profiler which I found invaluable. dotTrace generates some very readable snapshots and makes it easy to compare each incremental improvement you make.
</p><p>
Sorry I haven't included more code with this article, but it's work code and not really mine to share. I just wanted to highlight where the high yield performance increases came from. Hope you find it helpful.
</p><p>
EDIT: First time around, I forgot to escape all the &lt; and &gt;
<br />
EDIT AGAIN: Jesus, this wordpress thing really hates code snippets, i've tidied up the formatting but it's still ugly.</p>
