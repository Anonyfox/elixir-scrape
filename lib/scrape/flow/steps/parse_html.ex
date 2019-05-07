defmodule Scrape.Flow.Steps.ParseHTML do
  @moduledoc false

  def execute(%{html: html}) when not is_binary(html) do
    {:error, {:html_error, html}}
  end

  def execute(%{html: ""}) do
    {:error, {:html_error, ""}}
  end

  def execute(%{html: html}) when is_binary(html) do
    {:ok, %{dom: Floki.parse(html)}}
  end

  def execute(_) do
    {:error, :html_missing}
  end
end
