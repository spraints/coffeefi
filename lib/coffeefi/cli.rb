command = ARGV.shift
case command
when '-v', '--version'
  puts "Coffee-fi #{File.read(File.expand_path('../../../VERSION', __FILE__))}"
  exit 0
when 'install', 'uninstall'
  require 'coffeefi/installer'
  Coffeefi::Installer.send(command, *ARGV)
when 'check'
  require 'coffeefi/controller'
  Coffeefi::Controller.new.run
else
  puts <<USAGE
Usage: #{$0} command
Command can be one of
  install
  uninstall
  check
USAGE
end
