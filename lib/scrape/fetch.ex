defmodule Scrape.Fetch do
  @opts [
    follow_redirect: true,
    timeout: 33_000,
    recv_timeout: 30_000,
    ssl: [{:versions, [:'tlsv1.2']}]
  ]
  @headers [
    "user-agent": "Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36",
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
  ]

  def run(url, http_headers \\ @headers, http_opts \\ @opts) do
    url
    |> HTTPoison.get(http_headers, http_opts)
    |> evaluate
  end

  defp evaluate({:error, _}), do: ""
  defp evaluate({:ok, %HTTPoison.Response{status_code: 200} = response}) do
    cs = charset(response.headers)

    if cs do
      encoding = cs
      |> String.replace("-","_")
      |> String.downcase
      |> to_char_list
      |> List.to_atom

      {_status, result} = Codepagex.to_string response.body, encoding

      result
    else
      response.body
    end
  end
  defp evaluate(_), do: ""

  defp charset(headers) do
    header = headers
    |> Enum.filter(fn({k,_}) -> k == "Content-Type" end)
    |> first

    if header do
      {_name, content} = header

      ~r/charset=(ISO-8859-[1-9])/i
      |> Regex.run(content, capture: :all_but_first)
      |> first
    else
      nil
    end
  end

  defp first([h|_]), do: h
  defp first(_), do: nil
end
