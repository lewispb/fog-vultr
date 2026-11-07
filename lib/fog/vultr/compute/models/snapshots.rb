require "fog/core/collection"
require "fog/vultr/compute/models/snapshot"

module Fog
  module Vultr
    class Compute
      class Snapshots < Fog::Collection
        model Fog::Vultr::Compute::Snapshot

        # Every snapshot, across pages. Filter: description.
        def all(filters = {})
          load service.list_all(:list_snapshots, "snapshots", **filters)
        end

        def get(id)
          new service.get_snapshot(id).body.fetch("snapshot")
        rescue NotFound
          nil
        end
      end
    end
  end
end
