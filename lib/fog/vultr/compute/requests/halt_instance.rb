module Fog
  module Vultr
    class Compute
      class Real
        def halt_instance(id)
          request method: :post, path: "instances/#{id}/halt", expects: 204
        end
      end

      class Mock
        def halt_instance(id)
          find(:instances, id)["power_status"] = "stopped"
          response 204
        end
      end
    end
  end
end
