module Fog
  module Vultr
    class Compute
      class Real
        def list_regions(query = {})
          request method: :get, path: "regions", query: query, expects: 200
        end
      end

      class Mock
        def list_regions(query = {})
          page "regions", REGIONS, query
        end
      end
    end
  end
end
