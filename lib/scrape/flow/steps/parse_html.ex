defmodule Scrape.Flow.Steps.ParseHTML do
  @moduledoc false

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(%{html: html}, _) when not is_binary(html) do
    {:error, {:html_error, html}}
  end

  def execute(%{html: ""}, _) do
    {:error, {:html_error, ""}}
  end

  def execute(%{html: html}, _) when is_binary(html) do
    {:ok, %{dom: Floki.parse(html)}}
  end

  def execute(_, _) do
    {:error, :html_missing}
  end
end
