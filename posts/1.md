Dealing with multiple models and validation in one view
---
I had been having a little trouble with validating multiple child models when creating/editing the parent. Error messages were unintelligible and a little annoying.

Ed Thomson has a <a href="http://www.edwardthomson.com/blog/2006/04/rails_validations_with_multipl.html">pretty good idea</a> for tidying up those ActiveRecord::Errors but it was a little too specific for me. I've now made a more general method for tidying up the error messages which I put in the ApplicationHelper.

<!--more-->
<pre><code>def tidy_error_messages(model, included_model_names)
new_errors = ActiveRecord::Errors.new(nil)

model.errors.each do |key, message|
new_errors.add(key, message) unless included_model_names.include? key
end

# re-jig the errors for the included models
for included_model_name in included_model_names
for included_model in model.send(included_model_name)
included_model.errors.each do |key, message|
# use a custom error message if the model supports it
if included_model.respond_to? :create_error_message
included_model.create_error_message(new_errors, key, message)
else
new_errors.add(included_model_name, "#{key} #{message}")
end
end
end

# wipe out the old errors and chuck the new ones in
model.errors.clear
new_errors.each do |key, message|
model.errors.add key, message
end
end</code></pre>
This gives me a nice general solution that I can use in all of my models. If I want a custom message for any of my included models I just have to define create_error_message on the model. If I can't be bothered then there is a nice default message that will be created instead.
