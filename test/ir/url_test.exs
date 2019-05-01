defmodule Scrape.IR.URLTest do
  use ExUnit.Case

  alias Scrape.IR.URL

  doctest URL

  describe "URL.merge/2" do
    test "can merge relative paths" do
      root_url = "http://example.com"
      assert URL.merge("/path", root_url) == "http://example.com/path"
      assert URL.merge("/path", root_url <> "/something") == "http://example.com/path"
    end
  end
end
