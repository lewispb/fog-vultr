module Fog
  module Vultr
    class Compute
      class Real
        # A page of snapshots. Filter: description.
        def list_snapshots(query = {})
          request method: :get, path: "snapshots", query: query, expects: 200
        end
      end

      class Mock
        def list_snapshots(query = {})
          snapshots = data[:snapshots].values.select { |snapshot| query[:description].nil? || snapshot["description"] == query[:description] }
          page "snapshots", snapshots, query
        end
      end
    end
  end
end
