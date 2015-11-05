# Scrape

An Elixir package to scrape websites. This is an attempt to rewrite
[meteor-scrape](https://github.com/Anonyfox/meteor-scrape) from scratch,
leveraging the expressiveness and power of Elixir. Current features:

- can handle non-utf-8 sources.
- parse common websites
- parse RSS/Atom feeds

## Installation

Add `scrape` to your mixfile:

````Elixir
{:scrape, "~> 0.1"}
````

## Usage

````Elixir
# Feed scraping:
Scrape.feed "http://feeds.venturebeat.com/VentureBeat"

# result (list of items):
[
  %{
    categories: ["mobile advertising", "Mobile", "ad blockers", "Marketing"],
    description: "<p>Advertisers are very [...shortened..."],
    image:   "http://i2.wp.com/venturebeat.com/wp-content/uploads/2015/11/FullSizeRender1.jpg?resize=160%2C140",
    pubdate: %Timex.DateTime{
      calendar: :gregorian,
      day: 5,
      hour: 22,
      minute: 40,
      month: 11,
      ms: 0,
      second: 33,
      timezone: %Timex.TimezoneInfo{
        abbreviation: "UTC",
        from: :min,
        full_name: "UTC",
        offset_std: 0,
        offset_utc: 0,
        until: :max},
      year: 4015},
    title: "Advertising industry challenged to [...shortened...]",
    url: "http://venturebeat.com/2015/11/05/advertising-industry-challenged-to-create-ads-that-people-dont-want-to-block/"},
    %{...},
  ...
]
````

````Elixir
# Scrape a website:
Scrape.website "http://montrealgazette.com/"

# Result (basic metadata):
%Scrape.Website{
  description: "The latest news and headlines from Montreal and Quebec. Get breaking news, stories and in-depth analysis on business, sports, arts, lifestyle and weather.",
  favicon: "http://0.gravatar.com/blavatar/ab6c5a9287c37a4f2ebe4dac7a314814?s=114",
  feeds: ["http://montrealgazette.com/feed"],
  image: "http://0.gravatar.com/blavatar/ab6c5a9287c37a4f2ebe4dac7a314814?s=200&ts=1446766105",
  title: "Montreal Gazette",
  url: "http://montrealgazette.com/"
}
````

## License

LGPLv3. Use this library however you want, but I want improvements & bugfixes
to flow back into this package. 
