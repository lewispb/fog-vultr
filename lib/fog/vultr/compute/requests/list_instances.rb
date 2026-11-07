module Fog
  module Vultr
    class Compute
      class Real
        # A page of instances. Filters: tag, label, main_ip, region;
        # per_page and cursor page through them.
        def list_instances(query = {})
          request method: :get, path: "instances", query: query, expects: 200
        end
      end

      class Mock
        FILTERS = { tag: "tags", label: "label", main_ip: "main_ip", region: "region" }

        def list_instances(query = {})
          instances = data[:instances].values.select { |instance| filtered?(instance, query) }
          page "instances", instances, query
        end

        private
          def filtered?(instance, query)
            FILTERS.all? do |filter, field|
              wanted = query[filter]
              wanted.nil? || Array(instance[field]).include?(wanted)
            end
          end
      end
    end
  end
end
