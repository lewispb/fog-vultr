require "fog/core/collection"
require "fog/vultr/compute/models/region"

module Fog
  module Vultr
    class Compute
      class Regions < Fog::Collection
        model Fog::Vultr::Compute::Region

        def all
          load service.list_all(:list_regions, "regions")
        end

        def get(id)
          all.find { |region| region.id == id }
        end
      end
    end
  end
end
