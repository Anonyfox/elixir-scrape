defmodule Scrape.Flow.DomainTest do
  use ExUnit.Case

  alias Scrape.Flow.Domain

  describe "Domain#from_url" do
  end

  describe "Domain#from_file" do
    test "works when a valid domain file exists" do
      {:ok, data} = Domain.from_file("cache/domain/venturebeat.html")
      assert data.title =~ "Fortnite teams up with Avengers"
      assert length(data.feed_urls) == 3
    end

    test "refuses when no file exists" do
      {:error, error} = Domain.from_file("missing")
      assert error == {:disk_error, :enoent}
    end
  end

  describe "Domain#from_string" do
    test "works when a valid string is given" do
      html = File.read!("cache/domain/venturebeat.html")
      {:ok, data} = Domain.from_string(html)
      assert data.title =~ "Fortnite teams up with Avengers"
      assert length(data.feed_urls) == 3
    end

    test "refuses when nil is given" do
      {:error, error} = Domain.from_string(nil)
      assert error == {:html_error, nil}
    end

    test "refuses when empty string is given" do
      {:error, error} = Domain.from_string("")
      assert error == {:html_error, ""}
    end
  end
end
