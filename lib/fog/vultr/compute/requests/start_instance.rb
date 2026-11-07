module Fog
  module Vultr
    class Compute
      class Real
        def start_instance(id)
          request method: :post, path: "instances/#{id}/start", expects: 204
        end
      end

      class Mock
        def start_instance(id)
          find(:instances, id)["power_status"] = "running"
          response 204
        end
      end
    end
  end
end
