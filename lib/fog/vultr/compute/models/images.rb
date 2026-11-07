require "fog/core/collection"
require "fog/vultr/compute/models/image"

module Fog
  module Vultr
    class Compute
      class Images < Fog::Collection
        model Fog::Vultr::Compute::Image

        def all
          load service.list_all(:list_os, "os")
        end

        def get(id)
          all.find { |image| image.id == Integer(id) }
        end
      end
    end
  end
end
