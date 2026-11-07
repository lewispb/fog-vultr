require "fog/core/collection"
require "fog/vultr/compute/models/flavor"

module Fog
  module Vultr
    class Compute
      class Flavors < Fog::Collection
        model Fog::Vultr::Compute::Flavor

        # Every plan, across pages. Filters: type and os, as for list_plans.
        def all(filters = {})
          load service.list_all(:list_plans, "plans", **filters)
        end

        def get(id)
          all(type: "all").find { |flavor| flavor.id == id }
        end
      end
    end
  end
end
