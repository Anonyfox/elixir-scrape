defmodule FetchTest do
  use ExUnit.Case
  alias Scrape.Fetch
  @moduletag :external

  test "works for english utf-8 website" do
    html = Fetch.run "http://www.bbc.com"
    assert html =~ "BBC"
  end

  test "works for german ISO website" do
    html = Fetch.run "http://www.spiegel.de"
    assert html =~ "SPIEGEL"
  end
end
