module Fog
  module Vultr
    class Compute
      class Real
        def list_firewall_rules(firewall_group_id, query = {})
          request method: :get, path: "firewalls/#{firewall_group_id}/rules", query: query, expects: 200
        end
      end

      class Mock
        def list_firewall_rules(firewall_group_id, query = {})
          find :firewall_groups, firewall_group_id
          page "firewall_rules", data[:firewall_rules][firewall_group_id].values, query
        end
      end
    end
  end
end
