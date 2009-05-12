Forgot to create a bunch of specs?
---
<p>I got a little ahead of myself last week and wasn't a very good test first developer. I would like to say last week was the only time, and that I will never do it again. Being more realistic I wrote a little rake task that will create the missing model specs for me (just so they will show up in rcov/rspec reports and make me feel bad)</p>
<code><pre>
desc "create missing rspecs for all models"
task :create_missing_model_specs do
  models = Dir.open("#{RAILS_ROOT}/app/models").collect {|file_name| file_name.split('.')[0] }
  models.each do |model|
    if model && model.size > 0
      spec_path = "#{RAILS_ROOT}/spec/models/#{model}_spec.rb"
      unless FileTest::exist?(spec_path)
        puts "creating missing #{model} spec"
        File.open(spec_path, "w") do |f|
          f.puts "require File.dirname(__FILE__) + '/../spec_helper'"
          f.puts "module #{model.camelize}Methods"
          f.puts "end"
          f.puts
          f.puts "describe #{model.camelize} do"
          f.puts "\tit \"should have boat-loads of coverage\""
          f.puts "end"
        end
      end
    end
  end
end
</pre></code>
<p>Probably not the cleanest implementation, but I'm doing this to save time, not waste it!</p>
