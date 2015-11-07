# Scrape

An Elixir package to scrape websites. This is an attempt to rewrite
[meteor-scrape](https://github.com/Anonyfox/meteor-scrape) from scratch,
leveraging the expressiveness and power of Elixir. Current features:

- can handle non-utf-8 sources.
- can deal with timezones.
- parse RSS/Atom feeds.
- parse common websites.
- parse advanced content websites ("articles").

## Installation

Add `scrape` to your mixfile:

````Elixir
{:scrape, "~> 0.2"}
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

````Elixir
# Scrape an article (aka "content website")
Scrape.article "http://www.bbc.com/news/world-europe-34753464"

# Result
%Scrape.Article{
  description: "The Russian plane crash in Egypt last week was not due to technical failures, French aviation officials familiar with the investigation tell the BBC.",
  favicon: "http://static.bbci.co.uk/news/1.96.1453/apple-touch-icon.png",
  feeds: ["http://www.bbc.co.uk/news/world-europe-34753464",
  "http://www.bbc.com/news/world-europe-34753464"],
  fulltext: "The Russian plane crash in Egypt last week was not due to technical failures, French aviation officials familiar with the investigation have told the BBC.\n\nOther French officials said the flight data recorder suggested a \"violent, sudden\" explosion caused the crash, killing all 224 people on board.\ [...shortened...]"
  image: "http://ichef-1.bbci.co.uk/news/1024/cpsprodpb/A4F2/production/_86562224_86562223.jpg",
  keywords: [
    %{accuracy: 1.0, name: "egypt"},
    %{accuracy: 1.0, name: "russia"},
    %{accuracy: 1.0, name: "bbc"},
    %{accuracy: 1.0, name: "crash"},
    %{accuracy: 1.0, name: "plane"},
    %{accuracy: 1.0, name: "french"},
    %{accuracy: 1.0, name: "russian"},
    %{accuracy: 0.7246376811594203, name: "officials"},
    %{accuracy: 0.7246376811594203, name: "tell"},
    %{accuracy: 0.4830917874396135, name: "technical"},
    %{accuracy: 0.4830917874396135, name: "familiar"},
    %{accuracy: 0.4830917874396135, name: "aviation"},
    %{accuracy: 0.4830917874396135, name: "week"},
    %{accuracy: 0.4830917874396135, name: "investigation"},
    %{accuracy: 0.24154589371980675, name: "news"},
    %{accuracy: 0.0966183574879227, name: "contact"},
    %{accuracy: 0.07246376811594203, name: "sharm"},
    %{accuracy: 0.07246376811594203, name: "tourism"},
    %{accuracy: 0.07246376811594203, name: "flights"},
    %{accuracy: 0.07246376811594203, name: "flight"}
  ],
  title: "Russian plane crash: French 'rule out engine failure' - BBC News",
  url: "http://www.bbc.com/news/world-europe-34753464"
}
````

## License

LGPLv3. Use this library however you want, but I want improvements & bugfixes
to flow back into this package.
