module Fog
  module Vultr
    class Compute
      class Real
        def reboot_instance(id)
          request method: :post, path: "instances/#{id}/reboot", expects: 204
        end
      end

      class Mock
        def reboot_instance(id)
          find(:instances, id)["power_status"] = "running"
          response 204
        end
      end
    end
  end
end
