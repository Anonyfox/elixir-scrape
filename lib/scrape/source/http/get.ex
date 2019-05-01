defmodule Scrape.Source.HTTP.Get do
  @opts [
    follow_redirect: true,
    timeout: 33_000,
    recv_timeout: 30_000,
    ssl: [{:versions, [:"tlsv1.2"]}]
  ]

  @headers [
    "user-agent":
      "Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36",
    accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
  ]

  def execute(url, http_headers \\ @headers, http_opts \\ @opts) do
    HTTPoison.get(url, http_headers, http_opts)
  end
end
