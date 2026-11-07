module Fog
  module Vultr
    class Compute
      class Real
        def delete_firewall_group(id)
          request method: :delete, path: "firewalls/#{id}", expects: 204
        end
      end

      class Mock
        def delete_firewall_group(id)
          find :firewall_groups, id
          data[:firewall_groups].delete(id)
          data[:firewall_rules].delete(id)
          response 204
        end
      end
    end
  end
end
