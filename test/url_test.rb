require "test_helper"

class MinlyUrlTest < Minitest::Test
  def setup
    @minly = Minly::Url.new
  end

  def set_token
    @minly.token= "PbDVNQK77-Sfd0nLx9AD5mwWfx-Ca-Cu3HaAv3D3WbQ"
  end

  def response_status(stat)
    assert_equal stat, @minly.status[:type]
  end

  def test_exists
    assert Minly::Url
  end

  def test_returns_long_url_for_a_minly
    VCR.use_cassette("expand_valid") do
      response = @minly.expand_minly("3")
      assert_equal "https://drive.google.com/drive/u/0/folders/0B1C3woZnW_mZTEZUc0hYaGJpakk", response["original"]
      response_status 'success'
    end
  end

  def test_returns_long_url_for_an_invalid_minly
    VCR.use_cassette("expand_invalid") do
      assert_raises("InvalidURIError"){ @minly.expand_minly("%$&$%*") }
      assert_empty @minly.expand_minly("0")
      response_status 'error'
    end
  end

  def test_returns_popular_minly
    VCR.use_cassette("popular") do
      url = @minly.popular_minlys
      assert_equal 5, url.size
      response_status 'success'
    end
  end

  def test_returns_recent_minly
    VCR.use_cassette("recent") do
      url = @minly.recent_minlys
      assert_equal 5, url.size
      response_status 'success'
    end
  end

  def test_shorten_minly_without_token
    VCR.use_cassette("no_token") do
      url = @minly.create_minly("http://www.wsj.com/articles/nigeria-plays-tough-game-of-chicken-with-smugglers-1447197546")
      assert_equal "http://www.wsj.com/articles/nigeria-plays-tough-game-of-chicken-with-smugglers-1447197546", url["original"]
      response_status "success"
    end
  end

  def test_create_minly_with_invalid_token_and_valid_vanity_string
    VCR.use_cassette("invalid_token") do
      refute @minly.create_minly("http://test_url.com", "test")
      response_status "error"
      assert_equal "Request requires a valid user token.", @minly.status[:info]
    end
  end

  def test_create_minly_with_nil_vanity_string
    VCR.use_cassette("nil_token") do
      set_token
      refute @minly.create_minly("http://test_url.com", nil)
    end
  end

  def test_create_minly_with_valid_token_and_valid_vanity_string
    VCR.use_cassette("valid_token") do
      set_token
      url = @minly.create_minly("http://test.com","test")
      assert_equal "http://test.com", url["original"]
      assert_equal "test", url["shortened"]
      response_status "success"
    end
  end

  def test_change_minly_target
    VCR.use_cassette("change_target") do
      refute @minly.change_minly_target("test", "http://minly.herokuapp.com")
      set_token
      url = @minly.change_minly_target("test", "http://minly.herokuapp.com")
      response_status "success"
      assert_equal "http://minly.herokuapp.com", url["original"]
    end
  end

  def test_change_minly_status
    VCR.use_cassette("change_status") do
      refute @minly.change_minly_status("test", false)
      set_token
      url = @minly.change_minly_status("test",false)
      response_status "success"
      refute url["active"]
    end
  end

  def test_destroys_minly
    VCR.use_cassette("destroy") do
      refute @minly.destroy_minly("test")
      set_token
      url = @minly.destroy_minly("test")
      response_status "success"
    end
  end

  def test_update_minly
    VCR.use_cassette("update") do
      refute @minly.update_minly("test","http://google.com", false)
      refute @minly.update_minly("test",nil, false)
      refute @minly.update_minly("test","", false)
      refute @minly.update_minly("test","http://bing.com", nil)
      refute @minly.update_minly("test","http://bing.com", "")
      assert_raises("ArgumentError"){@minly.update("test")}
      assert_raises("ArgumentError"){@minly.update("test", "")}
      assert_raises("ArgumentError"){@minly.update()}
      set_token
      url = @minly.update_minly("test", "http://bing.com", false)
      response_status "success"
    end
  end

  def test_process_response
    VCR.use_cassette("process_response") do
      assert_nil @minly.status
      assert_nil @minly.response
      reply = @minly.connection.get(API_SHOW_ACTION + "popular/")
      @minly.process_response(reply)
      assert @minly.status
      assert_equal @minly.response, JSON(reply.body)["payload"]
    end
  end

  def test_has_no_token_error_is_true_without_token
    assert @minly.has_no_token_error
    assert_equal "error", @minly.status[:type]
    @minly.token=0
    assert @minly.has_no_token_error
    assert_equal "error", @minly.status[:type]
  end

  def test_has_no_token_error_is_false_with_token
    assert @minly.has_no_token_error
    set_token
    refute @minly.has_no_token_error
  end

  def test_make_get_request
    @minly.stub(:process_response, "hello") do
      @minly.connection.stub(:get, "")do
        assert_equal "hello", @minly.make_get_request("")
      end
    end
  end

  def test_parse_status
    val = {"status" => "Hello", "status_info" => "World" }
    out = @minly.parse_status val
    assert_equal out[:type], val["status"]
    assert_equal out[:info], val["status_info"]
  end
end
