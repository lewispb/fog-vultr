module Fog
  module Vultr
    class Compute
      class Real
        def delete_firewall_rule(firewall_group_id, id)
          request method: :delete, path: "firewalls/#{firewall_group_id}/rules/#{id}", expects: 204
        end
      end

      class Mock
        def delete_firewall_rule(firewall_group_id, id)
          group = find(:firewall_groups, firewall_group_id)
          rules = data[:firewall_rules][firewall_group_id]
          rules.delete(Integer(id)) { raise NotFound, "404 Not found" }
          group["rule_count"] = rules.size
          response 204
        end
      end
    end
  end
end
