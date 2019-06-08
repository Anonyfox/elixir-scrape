# Scrape

[![Hex.pm](https://img.shields.io/hexpm/dt/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/v/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/l/scrape.svg)](https://hex.pm/packages/scrape)

Structured Data extraction from common web resources, using information-retrieval techniques. See the [docs](https://hexdocs.pm/scrape/Scrape.html)

## Installation

The package can be installed by adding `scrape` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scrape, "~> 3.0.0"}
  ]
end
```

## Known Issues

* This package uses an outdated version of `httpoison` because of `keepcosmos/readability`. You can override this in your app with `override: true` and everything should work.
* The current version 3.X is a complete rewrite from scratch, so some new issues might occur and the API has changed. Please provide some URL to a HTML/Feed document when submitting issues, so I can look into it for bugfixing.

## Usage

* `Scrape.domain!(url)` -> get structured data of a domain-type url (like https://bbc.com)
* `Scrape.feed!(url)` -> get structured data of a RSS/Atom feed
* `Scrape.article!(url)` -> get structured data of an article-type url 

## License

LGPLv3. You can use this package any way you want (including commercially), but I want bugfixes and improvements to flow back into this package for everyone's benefit.
