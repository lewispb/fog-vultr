require "fog/core"
require "fog/json"

require "fog/vultr/version"

module Fog
  module Vultr
    extend Fog::Provider

    autoload :Compute, "fog/vultr/compute"

    service :compute, "Compute"
  end
end
