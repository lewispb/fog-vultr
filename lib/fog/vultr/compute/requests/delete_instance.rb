module Fog
  module Vultr
    class Compute
      class Real
        def delete_instance(id)
          request method: :delete, path: "instances/#{id}", expects: 204
        end
      end

      class Mock
        def delete_instance(id)
          find :instances, id
          data[:instances].delete(id)
          response 204
        end
      end
    end
  end
end
