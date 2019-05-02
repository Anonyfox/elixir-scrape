defmodule Scrape.Flow.Domain do
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

  def fetch_html(%__MODULE__{url: url} = data) do
    case HTTP.get(url) do
      {:ok, html} -> %{data | html: html}
      _ -> %{data | halted: true, error: :http_error}
    end
  end

  def parse_html(%__MODULE__{halted: true} = data), do: data

  def parse_html(%__MODULE__{html: html} = data) do
    %{data | dom: Floki.parse(html)}
  end

  def extract_title(%__MODULE__{halted: true} = data), do: data

  def extract_title(%__MODULE__{dom: dom} = data) do
    %{data | title: DOM.title(dom)}
  end

  def extract_description(%__MODULE__{halted: true} = data), do: data

  def extract_description(%__MODULE__{dom: dom} = data) do
    %{data | description: DOM.description(dom)}
  end

  def extract_icon_url(%__MODULE__{halted: true} = data), do: data

  def extract_icon_url(%__MODULE__{dom: dom, url: url} = data) do
    %{data | icon_url: DOM.icon_url(dom, url)}
  end

  def extract_feed_urls(%__MODULE__{halted: true} = data), do: data

  def extract_feed_urls(%__MODULE__{dom: dom, url: url} = data) do
    %{data | feed_urls: DOM.feed_urls(dom, url)}
  end

  def finalize(%__MODULE__{halted: true, error: error}), do: {:error, error}

  def finalize(%__MODULE__{} = data) do
    keys = [:url, :title, :description, :icon_url, :feed_urls]
    {:ok, Map.take(data, keys)}
  end
end
