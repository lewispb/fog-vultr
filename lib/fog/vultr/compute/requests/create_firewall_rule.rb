module Fog
  module Vultr
    class Compute
      class Real
        # Adds an accept rule to a firewall group: ip_type (v4 or v6),
        # protocol (icmp, tcp, udp, gre, esp, ah), subnet and subnet_size,
        # and optionally port ("22" or "8000:8100"), source and notes.
        def create_firewall_rule(firewall_group_id, attributes)
          request method: :post, path: "firewalls/#{firewall_group_id}/rules", body: attributes, expects: 201
        end
      end

      class Mock
        def create_firewall_rule(firewall_group_id, attributes)
          group = find(:firewall_groups, firewall_group_id)
          attributes = attributes.transform_keys(&:to_s)
          require_keys attributes, "ip_type", "protocol", "subnet", "subnet_size"

          rules = data[:firewall_rules][firewall_group_id]
          rule = { "id" => (rules.keys.max || 0) + 1, "action" => "accept", "port" => "", "source" => "", "notes" => "" }.merge(attributes)
          rules[rule["id"]] = rule
          group["rule_count"] = rules.size
          response 201, "firewall_rule" => rule
        end
      end
    end
  end
end
