defmodule Scrape.Target.Feed do
  @keys [:url, :title, :description, :website_url]

  def build(flow_state) do
    Map.take(flow_state, @keys)
  end
end
