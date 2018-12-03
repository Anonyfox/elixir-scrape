defmodule Scrape.Feed do
  alias Scrape.Exquery
  alias Scrape.Util.Text

  def parse(xml, _url) do
    items = xml
    |> Floki.find("item, entry")
    |> transform_items

    items || []
  end

  def parse_minimal(xml) do
    xml
    |> Floki.find("item, entry")
    |> Enum.map(&find_url/1)
    |> Enum.filter(fn url -> String.length(url) > 0 end)
  end

  defp transform_items(items) when is_list (items) do
    Parallel.map items, &transform_item/1
  end

  defp transform_item(item) do
    %Scrape.FeedItem{
      title: find_title(item),
      description: find_description(item),
      url: find_url(item),
      tags: find_tags(item),
      image: find_image(item),
      pubdate: find_pubdate(item),
      author: find_author(item)
    }
  end

  defp find_title(item) do
    item |> Exquery.find("title") |> clean_text
  end

  defp find_description(item) do
    description = item |> Exquery.find("description")
    summary = description || item |> Exquery.find("summary")
    content = summary || item |> Exquery.find("content")

    clean_text content
  end

  defp find_url(item) do
    href = item |> Exquery.attr("link", "href", :first)
    url = if (href && href !== "") do
      href
    else
      item |> Exquery.find("link", :first)
    end

    clean_text url
  end

  defp find_tags(item) do
    item
    |> Exquery.find("category", :all)
    |> Enum.map(fn s -> s |> String.strip |> String.downcase end)
    |> Enum.map(fn c -> %{accuracy: 0.9, name: c} end) # *mostly* set by humans
  end

  defp find_image(item) do
    enclosure = item |> Exquery.attr("enclosure", "url")
    media = enclosure || item |> Exquery.attr("media, content", :first)

    if media do
      clean_text media
    else
      image_str = item |> Floki.raw_html
      rx = ~r/\ssrc=["']*(([^'"\s]+)\.(jpe?g)|(png))["'\s]/i
      results = Regex.run(rx, image_str || "", capture: :all_but_first)

      if results, do: clean_text(List.first(results)), else: nil
    end
  end

  defp find_pubdate(item) do
    item
    |> Exquery.find("updated,pubDate,pubdate", :first)
    |> clean_text
    |> try_date
  end

  defp find_author(item) do
    item
    |> Exquery.find("dc|creator, author name, author", :first)
    |> clean_text
  end

  @datetime_patterns [
    "{ISO}", "{ISOz}", "{RFC3339}", "{RFC3339z}", "{RFC1123z}", "{RFC1123}",
    "{RFC822}", "{RFC822z}", "{ANSIC}", "{UNIX}"
  ]

  defp try_date(str, patterns \\ @datetime_patterns)
  defp try_date(nil, _), do: Timex.now
  defp try_date(_, []), do: Timex.now
  defp try_date(str, [format | others]) do
    case Timex.parse(str, format) do
      {:ok, result} -> result
      _ -> try_date(str, others)
    end
  end

  defp clean_text(nil), do: nil
  defp clean_text(str) do
    str
    |> Text.without_js
    |> Text.without_html
    |> Text.normalize_whitespace
  end

end
