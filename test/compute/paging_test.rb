require "test_helper"

class PagingTest < VultrTest
  def test_loads_every_page_with_the_filters
    first = stub_vultr(:get, "instances?per_page=500&tag=ci", body: page("instances", [ fixture(:instance) ], "bmV4dF9fMQ=="))
    second = stub_vultr(:get, "instances?per_page=500&tag=ci&cursor=bmV4dF9fMQ==",
      body: page("instances", [ fixture(:instance).merge("id" => "second", "label" => "ci-2") ]))

    assert_equal [ "ci-1", "ci-2" ], compute.servers.all(tag: "ci").map(&:label)
    assert_requested first
    assert_requested second
  end
end
