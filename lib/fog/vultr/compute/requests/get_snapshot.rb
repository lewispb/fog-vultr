module Fog
  module Vultr
    class Compute
      class Real
        def get_snapshot(id)
          request method: :get, path: "snapshots/#{id}", expects: 200
        end
      end

      class Mock
        def get_snapshot(id)
          response 200, "snapshot" => find(:snapshots, id)
        end
      end
    end
  end
end
