require "fog/core/model"

module Fog
  module Vultr
    class Compute
      class Region < Fog::Model
        identity :id

        attribute :city
        attribute :country
        attribute :continent
        attribute :options, type: :array
        attribute :connectivity, type: :array

        # The ids of the plans the region can deploy now, optionally of one type
        def available_plans(type: nil)
          requires :id
          service.list_region_availability(id, { type: type }.compact).body.fetch("available_plans")
        end
      end
    end
  end
end
