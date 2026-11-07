require "fog/core/model"

module Fog
  module Vultr
    class Compute
      class FirewallGroup < Fog::Model
        identity :id

        attribute :description
        attribute :instance_count, type: :integer
        attribute :rule_count, type: :integer
        attribute :max_rule_count, type: :integer
        attribute :created_at, aliases: "date_created", type: :time
        attribute :modified_at, aliases: "date_modified", type: :time

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?

          merge_attributes service.create_firewall_group({ description: description }.compact).body.fetch("firewall_group")
          true
        end

        def destroy
          requires :id
          service.delete_firewall_group(id)
          true
        end

        def rules
          requires :id
          service.firewall_rules(firewall_group_id: id)
        end
      end
    end
  end
end
