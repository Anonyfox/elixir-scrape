defmodule ScrapeTest do
  use ExUnit.Case
  doctest Scrape

  test "greets the world" do
    assert Scrape.hello() == :world
  end
end
