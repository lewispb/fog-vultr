require "fog/core/collection"
require "fog/vultr/compute/models/firewall_group"

module Fog
  module Vultr
    class Compute
      class FirewallGroups < Fog::Collection
        model Fog::Vultr::Compute::FirewallGroup

        def all
          load service.list_all(:list_firewall_groups, "firewall_groups")
        end

        def get(id)
          new service.get_firewall_group(id).body.fetch("firewall_group")
        rescue NotFound
          nil
        end
      end
    end
  end
end
