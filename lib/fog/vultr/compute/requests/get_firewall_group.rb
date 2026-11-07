module Fog
  module Vultr
    class Compute
      class Real
        def get_firewall_group(id)
          request method: :get, path: "firewalls/#{id}", expects: 200
        end
      end

      class Mock
        def get_firewall_group(id)
          response 200, "firewall_group" => find(:firewall_groups, id)
        end
      end
    end
  end
end
