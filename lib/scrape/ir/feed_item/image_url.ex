defmodule Scrape.IR.FeedItem.ImageURL do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.Text

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    enclosure(dom) || media(dom) || inline(dom) || ""
  end

  defp enclosure(dom) do
    case Query.attr(dom, "enclosure", "url", :first) do
      match when is_binary(match) -> Text.clean(match)
      [match] when is_binary(match) -> Text.clean(match)
      [match | _] when is_binary(match) -> Text.clean(match)
      _ -> nil
    end
  end

  defp media(dom) do
    case Query.attr(dom, "media", "content", :first) do
      match when is_binary(match) -> Text.clean(match)
      [match] when is_binary(match) -> Text.clean(match)
      [match | _] when is_binary(match) -> Text.clean(match)
      _ -> nil
    end
  end

  defp inline(dom) do
    rx = ~r/\ssrc=["']*(([^'"\s]+)\.(jpe?g)|(png))["'\s]/i
    str = Floki.raw_html(dom, encode: false)

    case Regex.run(rx, str, capture: :all_but_first) do
      [match] when is_binary(match) -> Text.clean(match)
      [match | _] when is_binary(match) -> Text.clean(match)
      _ -> nil
    end
  end
end
