
module Coffeefi
  module MaybeGrowl
begin
    require 'growl'
    def method_missing(*args)
      Growl.send(*args)
    end
rescue LoadError
    def method_missing(*args)
    end
end
    extend self
  end
end
