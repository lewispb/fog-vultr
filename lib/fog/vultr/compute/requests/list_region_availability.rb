module Fog
  module Vultr
    class Compute
      class Real
        # The plans a region can deploy now. Filter: type, as for list_plans.
        def list_region_availability(id, query = {})
          request method: :get, path: "regions/#{id}/availability", query: query, expects: 200
        end
      end

      class Mock
        def list_region_availability(id, query = {})
          raise NotFound, "404 Not found" unless REGIONS.any? { |region| region["id"] == id }

          plans = PLANS.select { |plan| plan["locations"].include?(id) && (query[:type].nil? || plan["type"] == query[:type]) }
          response 200, "available_plans" => plans.map { |plan| plan["id"] }
        end
      end
    end
  end
end
