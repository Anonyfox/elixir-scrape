defmodule Scrape.Target.Article do
  @keys [:url, :title, :text, :summary, :language, :stems, :image_url]

  def build(flow_state) do
    Map.take(flow_state, @keys)
  end
end
