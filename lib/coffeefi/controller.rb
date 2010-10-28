require 'net/http'
require 'uri'
require 'coffeefi/maybe_growl'

module Coffeefi
  class Controller
    def run
      if need_to_register?
        MaybeGrowl.notify_warn('TODO: actually register!')
      end
    end

    private

    def need_to_register?
      !google_is_google?
    end

    def google_is_google?
      url = URI.parse 'http://www.google.com/'
      Net::HTTP.start(url.host, url.port) do |http|
        'gws' == http.get('/')['server']
      end
    end
  end
end
