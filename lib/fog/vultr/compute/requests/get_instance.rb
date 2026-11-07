module Fog
  module Vultr
    class Compute
      class Real
        def get_instance(id)
          request method: :get, path: "instances/#{id}", expects: 200
        end
      end

      class Mock
        def get_instance(id)
          response 200, "instance" => find(:instances, id)
        end
      end
    end
  end
end
