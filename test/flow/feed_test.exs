defmodule Scrape.Flow.FeedTest do
  use ExUnit.Case

  alias Scrape.Flow.Feed

  describe "Feed#from_url" do
  end

  describe "Feed#from_string" do
    test "works when a valid string is given" do
      xml = File.read!("cache/feed/latimes.xml")
      {:ok, data} = Feed.from_string(xml)
      assert data.title =~ "latimes.com - Los Angeles Times"
      assert data.website_url == "http://www.latimes.com"

      item = data[:items] |> List.first()
      item.title =~ "guitar"
    end

    test "refuses when nil is given" do
      {:error, error} = Feed.from_string(nil)
      assert error == :xml_invalid
    end

    test "refuses when empty string is given" do
      {:error, error} = Feed.from_string("")
      assert error == :xml_invalid
    end
  end
end
