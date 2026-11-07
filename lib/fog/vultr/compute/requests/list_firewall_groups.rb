module Fog
  module Vultr
    class Compute
      class Real
        def list_firewall_groups(query = {})
          request method: :get, path: "firewalls", query: query, expects: 200
        end
      end

      class Mock
        def list_firewall_groups(query = {})
          page "firewall_groups", data[:firewall_groups].values, query
        end
      end
    end
  end
end
