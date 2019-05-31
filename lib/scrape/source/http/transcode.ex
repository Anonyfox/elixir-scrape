defmodule Scrape.Source.HTTP.Transcode do
  def execute(charset, text) do
    encoding = charset_to_encoding(charset)
    {_status, result} = Codepagex.to_string(text, encoding)
    result
  end

  defp charset_to_encoding(charset) do
    charset
    |> String.replace("-", "_")
    |> String.downcase()
    |> to_charlist
    |> List.to_atom()
  end
end
