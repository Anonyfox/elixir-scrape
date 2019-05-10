defmodule Scrape.Flow.Steps.FetchDocument do
  @moduledoc false

  use Scrape.Flow.Step

  alias Scrape.Source.Disk
  alias Scrape.Source.HTTP

  def execute(%{url: nil, path: nil}, _), do: {:error, :fetch_error}

  def execute(%{url: url, path: nil}, _) when not is_binary(url) do
    fail({:url_error, url})
  end

  def execute(%{url: nil, path: path}, _) when not is_binary(path) do
    fail({:path_error, path})
  end

  def execute(%{url: url, path: path}, _) when is_binary(url) and is_binary(path) do
    fail(:source_error)
  end

  def execute(%{url: url}, _) when is_binary(url) do
    case HTTP.get(url) do
      {:ok, html} -> assign(html: html)
      {:error, reason} -> fail({:http_error, reason})
    end
  end

  def execute(%{path: path}, _) when is_binary(path) do
    case Disk.get(path) do
      {:ok, html} -> assign(html: html)
      {:error, reason} -> fail({:disk_error, reason})
    end
  end
end
