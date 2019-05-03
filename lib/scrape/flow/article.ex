defmodule Scrape.Flow.Article do
  @moduledoc false

  alias Scrape.IR.DOM
  alias Scrape.IR.Text
  alias Scrape.Source.HTTP

  defstruct [
    :halted,
    :error,
    :url,
    :html,
    :dom,
    :title,
    :image_url,
    :text,
    :body,
    :language,
    :summary,
    :stems
  ]

  def execute(url) do
    %__MODULE__{url: url}
    |> fetch_html()
    |> parse_html()
    |> extract_title()
    |> extract_image()
    |> extract_body()
    |> extract_text()
    |> detect_language()
    |> extract_stems()
    |> extract_summary()
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

  defp extract_image(%{halted: true} = data), do: data

  defp extract_image(%{dom: dom} = data) do
    %{data | image_url: DOM.image_url(dom)}
  end

  defp extract_body(%{halted: true} = data), do: data

  defp extract_body(%{html: html} = data) do
    %{data | body: html |> DOM.paragraphs() |> Enum.join(".\n\n")}
  end

  defp extract_text(%{halted: true} = data), do: data

  defp extract_text(%{html: html} = data) do
    %{data | text: DOM.content(html)}
  end

  defp detect_language(%{halted: true} = data), do: data

  defp detect_language(%{text: nil, body: body} = data) do
    %{data | language: Text.detect_language(body)}
  end

  defp detect_language(%{text: text} = data) do
    %{data | language: Text.detect_language(text)}
  end

  defp extract_stems(%{halted: true} = data), do: data

  defp extract_stems(%{text: nil, body: body, language: language} = data) do
    %{data | stems: Text.semantic_keywords(body, 30, language)}
  end

  defp extract_stems(%{text: text, language: language} = data) do
    %{data | stems: Text.semantic_keywords(text, 30, language)}
  end

  defp extract_summary(%{halted: true} = data), do: data

  defp extract_summary(%{text: nil, body: body, language: language, stems: stems} = data) do
    %{data | summary: Text.extract_summary(body, stems, language)}
  end

  defp extract_summary(%{text: text, stems: stems, language: language} = data) do
    %{data | summary: Text.extract_summary(text, stems, language)}
  end

  defp finalize(%{halted: true, error: error}), do: {:error, error}

  defp finalize(data) do
    keys = [:url, :title, :text, :summary, :language, :stems, :image_url]
    {:ok, Map.take(data, keys)}
  end
end
