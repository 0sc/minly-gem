require "test_helper"

class MinlyUrlTest < Minitest::Test
  def test_exists
    assert Minly::Url
  end

  def test_it_returns_long_url_for_a_short_url
    VCR.use_cassette("one_url") do
      url = Minly::Url.expand("book")
      assert_equal "http://facebook.com", url
    end
  end
end
