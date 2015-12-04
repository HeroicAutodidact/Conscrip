require 'guard/compat/plugin'
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"


guard :jasmine, :server => :jasmine_gem, :port=>8888, :jasmine_url => 'http://localhost:8888/', :server_timeout => 120 do
  watch(%r{spec\/javascripts\/.+})
  watch(%r{js\/(.+)\.js}) { |m| "spec/javascripts/#{m[1]}_spec.js" }
  #watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end

guard 'livereload', :notify=>true do
  watch(%r{js\/.*\.js}){'index.html'}
  watch(%r{index.html})
end

#Convert my app from coffeescript to javascript
# coffeescript_options = {
#   input: 'app/assets/coffee',
#   output: 'app/assets/js',
#   source_map: true,
#   bare: true,
#   patterns: [%r{^app/assets/coffee/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
# }

# guard 'coffeescript', coffeescript_options do
#   coffeescript_options[:patterns].each { |pattern| watch(pattern) }
# end

# #Watch the specs directory and convert jasmine coffees to jasmine js files
# coffeescript_options = {
#   input: 'spec/coffee',
#   output: 'spec/javascripts',
#   bare: true,
#   patterns: [%r{^spec/coffee/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
# }

# guard 'coffeescript', coffeescript_options do
#   coffeescript_options[:patterns].each { |pattern| watch(pattern) }
# end


#Tape guard
guard :shell do
  watch %r{app\/assets\/.*\.coffee} do |m|
    `webpack -d`
  end
  watch %r{test\/(.*)\.coffee} do |m|
    `coffeetape '#{m[0]} | tap-spec'`
  end
end
