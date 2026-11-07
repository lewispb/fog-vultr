require "test_helper"

class FirewallTest < VultrTest
  def test_creates_a_group
    stub = stub_request(:post, "#{API}/firewalls")
      .with(body: { "description" => "ci" })
      .to_return(status: 201, body: JSON.generate("firewall_group" => fixture(:firewall_group)))

    assert_equal "1d5a6c8f", compute.firewall_groups.create(description: "ci").id
    assert_requested stub
  end

  def test_adds_a_rule_to_a_group
    group = compute.firewall_groups.new(fixture(:firewall_group))
    stub = stub_request(:post, "#{API}/firewalls/1d5a6c8f/rules")
      .with(body: { "ip_type" => "v4", "protocol" => "tcp", "subnet" => "198.51.100.0", "subnet_size" => 24, "port" => "22", "notes" => "controller" })
      .to_return(status: 201, body: JSON.generate("firewall_rule" => fixture(:firewall_rule)))

    rule = group.rules.create(ip_type: "v4", protocol: "tcp", subnet: "198.51.100.0", subnet_size: 24, port: "22", notes: "controller")

    assert_requested stub
    assert_equal 1, rule.id
  end

  def test_lists_and_removes_a_groups_rules
    group = compute.firewall_groups.new(fixture(:firewall_group))
    stub_vultr :get, "firewalls/1d5a6c8f/rules?per_page=500", body: page("firewall_rules", [ fixture(:firewall_rule) ])
    stub = stub_vultr(:delete, "firewalls/1d5a6c8f/rules/1", status: 204)

    group.rules.get(1).destroy

    assert_requested stub
  end
end
