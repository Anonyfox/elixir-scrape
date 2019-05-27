defmodule Scrape.Flow.Article do
  @moduledoc false

  alias Scrape.Flow
  alias Scrape.IR.HTML
  alias Scrape.IR.Text

  def from_url(url, opts \\ []) do
    Flow.start([url: url], opts)
    |> Flow.assign(html: &Scrape.Source.HTTP.get!(&1[:url]))
    |> process_html()
  end

  def from_file(path, opts \\ []) do
    Flow.start([path: path], opts)
    |> Flow.assign(html: &Scrape.Source.Disk.get!(&1[:path]))
    |> process_html()
  end

  def from_string(string, opts \\ []) do
    Flow.start(%{html: string, url: nil}, opts)
    |> process_html()
  end

  defp process_html(%{assigns: %{html: nil}}), do: {:error, :html_invalid}

  defp process_html(%{assigns: %{html: ""}}), do: {:error, :html_invalid}

  defp process_html(flow) do
    flow
    |> Flow.assign(dom: &Floki.parse(&1[:html]))
    |> Flow.assign(title: &HTML.title(&1[:dom]))
    |> Flow.assign(image_url: &HTML.image_url(&1[:dom], &1[:url]))
    |> Flow.assign(text: fn %{html: html} -> HTML.content(html) || HTML.sentences(html) end)
    |> Flow.assign(language: &Text.detect_language(&1[:text]))
    |> Flow.assign(stems: &Text.semantic_keywords(&1[:text], 30, &1[:language]))
    |> Flow.assign(summary: &Text.extract_summary(&1[:text], &1[:stems], &1[:language]))
    |> Flow.finish([:url, :title, :text, :summary, :language, :stems, :image_url])
  end
end
