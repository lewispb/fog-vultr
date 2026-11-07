module Fog
  module Vultr
    class Compute
      class Real
        # A page of plans. Filters: type (vc2, vhf, voc, vx1, vcg, all) and
        # os (windows, for the plans Windows runs on).
        def list_plans(query = {})
          request method: :get, path: "plans", query: query, expects: 200
        end
      end

      class Mock
        def list_plans(query = {})
          plans = PLANS.select { |plan| query[:type].nil? || query[:type] == "all" || plan["type"] == query[:type] }
          page "plans", plans, query
        end
      end
    end
  end
end
