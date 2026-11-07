module Fog
  module Vultr
    class Compute
      class Real
        def delete_snapshot(id)
          request method: :delete, path: "snapshots/#{id}", expects: 204
        end
      end

      class Mock
        def delete_snapshot(id)
          find :snapshots, id
          data[:snapshots].delete(id)
          response 204
        end
      end
    end
  end
end
