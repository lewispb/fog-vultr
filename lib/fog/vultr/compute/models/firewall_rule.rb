require "fog/core/model"

module Fog
  module Vultr
    class Compute
      # An accept rule in a firewall group. port is one port ("22") or a
      # range ("8000:8100"); subnet and subnet_size give the source network.
      class FirewallRule < Fog::Model
        CREATED = [ :ip_type, :protocol, :subnet, :subnet_size, :port, :source, :notes ]

        identity :id, type: :integer

        attribute :firewall_group_id
        attribute :action
        attribute :ip_type
        attribute :protocol
        attribute :port
        attribute :subnet
        attribute :subnet_size, type: :integer
        attribute :source
        attribute :notes

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?

          requires :firewall_group_id, :ip_type, :protocol, :subnet, :subnet_size
          merge_attributes service.create_firewall_rule(firewall_group_id, attributes.slice(*CREATED).compact).body.fetch("firewall_rule")
          true
        end

        def destroy
          requires :firewall_group_id, :id
          service.delete_firewall_rule(firewall_group_id, id)
          true
        end
      end
    end
  end
end
