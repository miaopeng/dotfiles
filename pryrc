$LOAD_PATH.unshift(File.expand_path("~/.rvm/gems/ruby-2.1.2/gems/awesome_print-1.2.0/lib"))

# === EDITOR ===
Pry.editor = 'vim'

# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil
Pry.commands.alias_command 'r!', 'reload!' rescue nil

Pry.config.color = true

# == PLUGINS ===

# awesome_print gem: great syntax colorized printing
# look at ~/.aprc for more settings for awesome_print

begin
 require 'awesome_print'
 Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError => err
 puts "gem install awesome_print  # <-- highly recommended"
end

# == Custom Commands ==

# Active Site
Pry::Commands.block_command "live", "Active a preview site" do |id|
  s = Monitoring::Site.find id
  adn = s.adn
  adn.active = true
  adn.chief_domain.refSystemAdn = 'default'
  adn.deactivated_at = nil if adn.deactivated_at.present?
  adn.save!
  output.puts s.host + " is live :)"
end

# Create A Cert Order
Pry::Commands.block_command "create_cert_order", "" do 
  Gs::CertOrder.create(:number => 'CECO1107208774', :switch => 1, :fqdn => 'www.yottaa.org')
  output.puts "Cert order created:)"
end
