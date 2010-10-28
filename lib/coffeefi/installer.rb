module Coffeefi
  class Installer
    def self.install
      new.install
    end
    def self.uninstall
      new.uninstall
    end

    def initialize
      plist_file = File.expand_path('~/Library/LaunchAgents/coffeefi.plist')
      @tasks = [
        LaunchdPlistWriter.new(plist_file),
        LaunchdLoader.new(plist_file)
      ]
    end

    def install
      @tasks.each do |task|
        task.install
      end
    end

    def uninstall
      @tasks.reverse.each do |task|
        task.uninstall
      end
    end

    class LaunchdPlistWriter
      def initialize plist_path
        @plist_path = plist_path
      end

      def install
        puts "Writing launchd configuration file..."
        File.open(@plist_path, 'w') do |f|
          f << plist
        end
      end

      def uninstall
        puts "Removing launchd configuration file..."
        if File.exists? @plist_path
          File.unlink(@plist_path)
        end
      end

      private

      def bin_path
        Gem.bin_path('coffeefi')
      rescue
        File.expand_path('../../../bin/coffeefi', __FILE__)
      end

      def plist
        <<-PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
	"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>org.rubygems.coffeefi</string>
	<key>ProgramArguments</key>
	<array>
		<string>#{bin_path}</string>
                <string>check</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/Library/Preferences/SystemConfiguration</string>
	</array>
        <!-- We specify PATH here because /usr/local/bin, where grownotify -->
        <!-- is usually installed, is not in the script path by default. -->
        <key>EnvironmentVariables</key>
        <dict>
                <key>PATH</key><string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/bin</string>
        </dict>
</dict>
</plist>
        PLIST
      end
    end

    class LaunchdLoader
      def initialize plist_path
        @plist_path = plist_path
      end

      def install
        puts "Registering with launchctl..."
        system 'launchctl', 'load', '-F', @plist_path
      end

      def uninstall
        puts "Unregistering with launchctl..."
        system 'launchctl', 'unload', @plist_path
      end
    end
  end
end
