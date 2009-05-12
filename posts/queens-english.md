Using proper english at RejectConf Berlin
---
<p>So I presented this little snippet at RejectConf last night. It's just a quick hack I wrote at lunch after dr. nic presented his meta-programming magic.</p>
<p>I wanted to write this because ever since I was 11 (when I learned BASIC) I've been using the american COLOR when I really meant COLOUR. Which isn't great</p>
<pre><code>

class Object
  def method_missing(meth, *args, &block)
    proper_english = { 'colour' => 'color',
                       'pluralise' => 'pluralize',
                       'metre' => 'meter' }

    american_method_name = proper_english[meth.to_s]
    if american_method_name
      puts "** Using the proper english to call method #{american_method_name}"
      return self.send(american_method_name, *args, &block)
    end
    super
  end
end

</pre></code>
