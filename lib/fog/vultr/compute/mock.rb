module Fog
  module Vultr
    class Compute
      # Fog.mock! stands this in for Real: an account kept in memory per API
      # key, with a few of Vultr's plans, regions and operating systems.
      # Instances are active and running as soon as they're created, and
      # snapshots complete at once. Lists page by an offset cursor.
      class Mock
        include Paging

        PLANS = [
          { "id" => "vc2-16c-64gb", "vcpu_count" => 16, "ram" => 65536, "disk" => 1280, "disk_count" => 1, "bandwidth" => 10240,
            "monthly_cost" => 320, "hourly_cost" => 0.438, "type" => "vc2", "locations" => [ "ewr", "ord", "sjc" ] },
          { "id" => "voc-g-16c-64gb-320s-amd", "vcpu_count" => 16, "ram" => 65536, "disk" => 320, "disk_count" => 1, "bandwidth" => 9216,
            "monthly_cost" => 480, "hourly_cost" => 0.658, "type" => "voc", "locations" => [ "ewr", "ord", "sjc" ] }
        ]
        REGIONS = [
          { "id" => "ewr", "city" => "New Jersey", "country" => "US", "continent" => "North America", "options" => [ "ddos_protection" ] },
          { "id" => "ord", "city" => "Chicago", "country" => "US", "continent" => "North America", "options" => [ "ddos_protection" ] },
          { "id" => "sjc", "city" => "Silicon Valley", "country" => "US", "continent" => "North America", "options" => [ "ddos_protection" ] }
        ]
        OPERATING_SYSTEMS = [
          { "id" => 2284, "name" => "Ubuntu 24.04 LTS x64", "arch" => "x64", "family" => "ubuntu" },
          { "id" => 501, "name" => "Windows 2022 Standard x64", "arch" => "x64", "family" => "windows" },
          { "id" => 2514, "name" => "Windows 2025 Standard x64", "arch" => "x64", "family" => "windows" }
        ]

        def self.data
          @data ||= Hash.new do |data, api_key|
            data[api_key] = { instances: {}, snapshots: {}, ssh_keys: {}, firewall_groups: {}, firewall_rules: Hash.new { |rules, id| rules[id] = {} } }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {})
          @api_key = options.fetch(:vultr_api_key)
        end

        def data
          self.class.data[@api_key]
        end

        def reset_data
          self.class.data.delete(@api_key)
        end

        private
          def response(status, body = nil)
            Excon::Response.new(status: status, body: body)
          end

          def page(key, items, query)
            offset = query.fetch(:cursor, 0).to_i
            per_page = query.fetch(:per_page, 100)
            following = offset + per_page < items.size ? (offset + per_page).to_s : ""

            response 200, key => items[offset, per_page] || [], "meta" => { "total" => items.size, "links" => { "next" => following, "prev" => "" } }
          end

          def find(collection, id)
            data[collection].fetch(id) { raise NotFound, "404 Not found" }
          end

          def require_keys(attributes, *keys)
            missing = keys.reject { |key| attributes.key?(key) || attributes.key?(key.to_s) }
            raise Error, "400 Missing #{missing.join(", ")}" if missing.any?
          end

          def now
            Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
          end

          def identifier
            Fog::UUID.uuid
          end
      end
    end
  end
end
