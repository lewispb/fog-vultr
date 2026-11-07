require "fog/core/collection"
require "fog/vultr/compute/models/firewall_rule"

module Fog
  module Vultr
    class Compute
      # The rules of one firewall group: compute.firewall_groups.get(id).rules
      class FirewallRules < Fog::Collection
        model Fog::Vultr::Compute::FirewallRule

        attribute :firewall_group_id

        def all
          requires :firewall_group_id
          load service.list_all(:list_firewall_rules, "firewall_rules", firewall_group_id)
        end

        def get(id)
          all.find { |rule| rule.id == Integer(id) }
        end

        def new(attributes = {})
          super({ firewall_group_id: firewall_group_id }.merge(attributes))
        end
      end
    end
  end
end
