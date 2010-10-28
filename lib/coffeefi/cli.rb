command = ARGV.shift
case command
when '-v', '--version'
  puts "Coffee-fi #{File.read(File.expand_path('../../../VERSION', __FILE__))}"
  exit 0
when 'install', 'uninstall'
  require 'coffeefi/installer'
  Coffeefi::Installer.send(command, *ARGV)
else
  puts <<USAGE
Usage: #{$0} command
Command can be one of
  install
  uninstall
USAGE
end
