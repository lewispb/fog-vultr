require "test_helper"

class RealTest < VultrTest
  def test_sends_the_api_key_and_user_agent
    stub = stub_request(:get, "#{API}/regions?per_page=500")
      .with(headers: { "Authorization" => "Bearer test-key", "User-Agent" => /\Afog-vultr\/#{Fog::Vultr::VERSION} / })
      .to_return(body: JSON.generate(page("regions", [])))

    compute.regions.all

    assert_requested stub
  end

  def test_raises_not_found_with_vultrs_message
    stub_vultr :get, "instances/missing", status: 404, body: { "error" => "Invalid instance-id.", "status" => 404 }

    error = assert_raises(Fog::Vultr::Compute::NotFound) { compute.get_instance("missing") }
    assert_equal "404 Invalid instance-id.", error.message
  end

  def test_raises_error_with_vultrs_message
    stub_vultr :post, "instances", status: 400, body: { "error" => "You have reached the maximum monthly fee limit for this account.", "status" => 400 }

    error = assert_raises(Fog::Vultr::Compute::Error) { compute.create_instance(region: "ewr", plan: "vc2-16c-64gb", os_id: 2284) }
    assert_equal "400 You have reached the maximum monthly fee limit for this account.", error.message
    assert_nil error.cause
  end

  def test_retries_a_rate_limited_create
    stub = stub_request(:post, "#{API}/instances")
      .to_return({ status: 429, body: "" }, { status: 202, body: JSON.generate("instance" => fixture(:pending_instance)) })

    assert_equal 202, compute.create_instance(region: "ewr", plan: "vc2-16c-64gb", os_id: 2284).status
    assert_requested stub, times: 2
  end

  def test_retries_a_list_that_fails_with_a_server_error
    stub = stub_request(:get, "#{API}/instances/#{fixture(:instance)["id"]}")
      .to_return({ status: 503, body: "" }, { status: 200, body: JSON.generate("instance" => fixture(:instance)) })

    assert_equal "ci-1", compute.servers.get(fixture(:instance)["id"]).label
    assert_requested stub, times: 2
  end

  def test_does_not_retry_a_create_that_fails_with_a_server_error
    stub = stub_vultr(:post, "instances", status: 500, body: { "error" => "Internal error", "status" => 500 })

    assert_raises(Fog::Vultr::Compute::Error) { compute.create_instance(region: "ewr", plan: "vc2-16c-64gb", os_id: 2284) }
    assert_requested stub, times: 1
  end

  def test_gives_up_after_the_retry_delays
    stub = stub_vultr(:get, "regions?per_page=500", status: 429, body: { "error" => "Rate limit reached", "status" => 429 })

    error = assert_raises(Fog::Vultr::Compute::Error) { compute.regions.all }
    assert_equal "429 Rate limit reached", error.message
    assert_requested stub, times: 4
  end

  def test_retries_a_delete_when_the_connection_drops
    stub = stub_request(:delete, "#{API}/instances/abc").to_raise(Excon::Error::Socket.new(Errno::ECONNRESET.new)).then.to_return(status: 204)

    assert_equal 204, compute.delete_instance("abc").status
    assert_requested stub, times: 2
  end
end
