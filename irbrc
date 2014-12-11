# === Awesome Print ===
$LOAD_PATH.unshift(File.expand_path("~/.rvm/gems/ruby-2.1.2/gems/awesome_print-1.2.0/lib"))

module PatchedAwesomePrint
  require 'awesome_print'
  ::Moped::BSON = ::BSON
end

begin
  include PatchedAwesomePrint
  AwesomePrint.irb!
rescue LoadError => err
  puts "Can not load Awesome Print"
end

