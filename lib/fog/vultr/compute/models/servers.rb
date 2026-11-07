require "fog/core/collection"
require "fog/vultr/compute/models/server"

module Fog
  module Vultr
    class Compute
      class Servers < Fog::Collection
        model Fog::Vultr::Compute::Server

        # Every instance, across pages. Filters: tag, label, main_ip, region.
        def all(filters = {})
          load service.list_all(:list_instances, "instances", **filters)
        end

        def get(id)
          new service.get_instance(id).body.fetch("instance")
        rescue NotFound
          nil
        end
      end
    end
  end
end
