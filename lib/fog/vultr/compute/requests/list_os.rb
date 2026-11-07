module Fog
  module Vultr
    class Compute
      class Real
        def list_os(query = {})
          request method: :get, path: "os", query: query, expects: 200
        end
      end

      class Mock
        def list_os(query = {})
          page "os", OPERATING_SYSTEMS, query
        end
      end
    end
  end
end
