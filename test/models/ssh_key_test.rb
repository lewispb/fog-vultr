require "test_helper"

class SshKeyTest < VultrTest
  def test_adds_a_key
    key = fixture(:ssh_key)
    stub = stub_request(:post, "#{API}/ssh-keys")
      .with(body: { "name" => "ci", "ssh_key" => key["ssh_key"] })
      .to_return(status: 201, body: JSON.generate("ssh_key" => key))

    assert_equal key["id"], compute.ssh_keys.create(name: "ci", public_key: key["ssh_key"]).id
    assert_requested stub
  end

  def test_removes_a_key
    stub = stub_vultr(:delete, "ssh-keys/#{fixture(:ssh_key)["id"]}", status: 204)

    compute.ssh_keys.new(fixture(:ssh_key)).destroy

    assert_requested stub
  end
end
