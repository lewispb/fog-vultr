require "json"
require "minitest/autorun"
require "webmock/minitest"

require "fog/vultr"
require "fog/vultr/compute"

class VultrTest < Minitest::Test
  API = "https://api.vultr.com/v2"

  def setup
    Fog.unmock!
  end

  private
    def compute
      @compute ||= Fog::Compute.new(provider: "Vultr", vultr_api_key: "test-key", retry_delays: [ 0, 0, 0 ])
    end

    def fixture(name)
      JSON.parse(File.read(File.join(__dir__, "fixtures", "#{name}.json")))
    end

    def stub_vultr(method, path, status: 200, body: nil)
      stub_request(method, "#{API}/#{path}").to_return(status: status, body: body && JSON.generate(body), headers: { "Content-Type" => "application/json" })
    end

    def page(key, items, following = "")
      { key => items, "meta" => { "total" => items.size, "links" => { "next" => following, "prev" => "" } } }
    end
end
