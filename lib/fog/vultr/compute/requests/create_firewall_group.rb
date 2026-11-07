module Fog
  module Vultr
    class Compute
      class Real
        # Creates a firewall group: an optional description.
        def create_firewall_group(attributes = {})
          request method: :post, path: "firewalls", body: attributes, expects: 201
        end
      end

      class Mock
        def create_firewall_group(attributes = {})
          group = {
            "id" => identifier[0, 8], "description" => attributes.transform_keys(&:to_s).fetch("description", ""),
            "date_created" => now, "date_modified" => now, "instance_count" => 0, "rule_count" => 0, "max_rule_count" => 50
          }
          data[:firewall_groups][group["id"]] = group
          response 201, "firewall_group" => group
        end
      end
    end
  end
end
