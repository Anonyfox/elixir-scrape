defmodule Scrape.Flow.Domain do
  @moduledoc false

  alias Scrape.IR.DOM
  alias Scrape.Source.HTTP

  defstruct [:halted, :error, :url, :html, :dom, :title, :description, :icon_url, :feed_urls]

  def execute(url) do
    %__MODULE__{url: url}
    |> fetch_html()
    |> parse_html()
    |> extract_title()
    |> extract_description()
    |> extract_icon_url()
    |> extract_feed_urls()
    |> finalize()
  end

  defp fetch_html(%{url: url} = data) do
    case HTTP.get(url) do
      {:ok, html} -> %{data | html: html}
      _ -> %{data | halted: true, error: :http_error}
    end
  end

  defp parse_html(%{halted: true} = data), do: data

  defp parse_html(%{html: html} = data) do
    %{data | dom: Floki.parse(html)}
  end

  defp extract_title(%{halted: true} = data), do: data

  defp extract_title(%{dom: dom} = data) do
    %{data | title: DOM.title(dom)}
  end

  defp extract_description(%{halted: true} = data), do: data

  defp extract_description(%{dom: dom} = data) do
    %{data | description: DOM.description(dom)}
  end

  defp extract_icon_url(%{halted: true} = data), do: data

  defp extract_icon_url(%{dom: dom, url: url} = data) do
    %{data | icon_url: DOM.icon_url(dom, url)}
  end

  defp extract_feed_urls(%{halted: true} = data), do: data

  defp extract_feed_urls(%{dom: dom, url: url} = data) do
    %{data | feed_urls: DOM.feed_urls(dom, url)}
  end

  defp finalize(%{halted: true, error: error}), do: {:error, error}

  defp finalize(data) do
    keys = [:url, :title, :description, :icon_url, :feed_urls]
    {:ok, Map.take(data, keys)}
  end
end
