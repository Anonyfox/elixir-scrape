defmodule Scrape.Target.FeedItem do
  @keys [:url, :title, :description, :image_url, :pubdate]

  def build(flow_state) do
    Map.take(flow_state, @keys)
  end
end
