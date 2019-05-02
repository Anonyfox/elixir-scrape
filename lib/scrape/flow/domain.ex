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

  defp fetch_html(%__MODULE__{url: url} = data) do
    case HTTP.get(url) do
      {:ok, html} -> %{data | html: html}
      _ -> %{data | halted: true, error: :http_error}
    end
  end

  defp parse_html(%__MODULE__{halted: true} = data), do: data

  defp parse_html(%__MODULE__{html: html} = data) do
    %{data | dom: Floki.parse(html)}
  end

  defp extract_title(%__MODULE__{halted: true} = data), do: data

  defp extract_title(%__MODULE__{dom: dom} = data) do
    %{data | title: DOM.title(dom)}
  end

  defp extract_description(%__MODULE__{halted: true} = data), do: data

  defp extract_description(%__MODULE__{dom: dom} = data) do
    %{data | description: DOM.description(dom)}
  end

  defp extract_icon_url(%__MODULE__{halted: true} = data), do: data

  defp extract_icon_url(%__MODULE__{dom: dom, url: url} = data) do
    %{data | icon_url: DOM.icon_url(dom, url)}
  end

  defp extract_feed_urls(%__MODULE__{halted: true} = data), do: data

  defp extract_feed_urls(%__MODULE__{dom: dom, url: url} = data) do
    %{data | feed_urls: DOM.feed_urls(dom, url)}
  end

  defp finalize(%__MODULE__{halted: true, error: error}), do: {:error, error}

  defp finalize(%__MODULE__{} = data) do
    keys = [:url, :title, :description, :icon_url, :feed_urls]
    {:ok, Map.take(data, keys)}
  end
end
