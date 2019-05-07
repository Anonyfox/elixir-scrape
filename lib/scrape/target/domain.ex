defmodule Scrape.Target.Domain do
  @keys [:url, :title, :description, :icon_url, :feed_urls]

  def build(flow_state) do
    Map.take(flow_state, @keys)
  end
end
