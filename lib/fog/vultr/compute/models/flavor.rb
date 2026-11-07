require "fog/core/model"

module Fog
  module Vultr
    class Compute
      # A plan. ram is in MB, disk in GB, bandwidth in GB a month.
      class Flavor < Fog::Model
        identity :id

        attribute :type
        attribute :vcpu_count, type: :integer
        attribute :ram, type: :integer
        attribute :disk, type: :integer
        attribute :disk_count, type: :integer
        attribute :disk_type
        attribute :bandwidth, type: :integer
        attribute :monthly_cost, type: :float
        attribute :hourly_cost, type: :float
        attribute :monthly_cost_preemptible, type: :float
        attribute :hourly_cost_preemptible, type: :float
        attribute :deploy_ondemand, type: :boolean
        attribute :deploy_preemptible, type: :boolean
        attribute :cpu_vendor
        attribute :locations, type: :array
        attribute :gpu_type
        attribute :gpu_vram_gb, type: :integer

        def available_in?(region)
          locations.to_a.include?(region.respond_to?(:id) ? region.id : region)
        end
      end
    end
  end
end
