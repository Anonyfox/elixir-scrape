defmodule Scrape.Feed do

  def parse(xml) do
    case FeederEx.parse(xml) do
      {:ok, feed, _} -> feed.entries
      _ -> []
    end
  end

end