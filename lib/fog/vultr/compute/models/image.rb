require "fog/core/model"

module Fog
  module Vultr
    class Compute
      # An operating system Vultr installs, by os_id
      class Image < Fog::Model
        identity :id, type: :integer

        attribute :name
        attribute :arch
        attribute :family

        def windows?
          family == "windows"
        end
      end
    end
  end
end
