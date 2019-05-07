defmodule Scrape.Flow.Steps.FetchHTML do
  @moduledoc false

  alias Scrape.Source.Disk
  alias Scrape.Source.HTTP

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(%{url: nil, path: nil}, _), do: {:error, :fetch_error}

  def execute(%{url: url, path: nil}, _) when not is_binary(url) do
    {:error, {:url_error, url}}
  end

  def execute(%{url: nil, path: path}, _) when not is_binary(path) do
    {:error, {:path_error, path}}
  end

  def execute(%{url: url, path: path}, _) when is_binary(url) and is_binary(path) do
    {:error, :source_error}
  end

  def execute(%{url: url}, _) when is_binary(url) do
    case HTTP.get(url) do
      {:ok, html} -> {:ok, %{html: html}}
      {:error, reason} -> {:error, {:http_error, reason}}
    end
  end

  def execute(%{path: path}, _) when is_binary(path) do
    case Disk.get(path) do
      {:ok, html} -> {:ok, %{html: html}}
      {:error, reason} -> {:error, {:disk_error, reason}}
    end
  end
end
