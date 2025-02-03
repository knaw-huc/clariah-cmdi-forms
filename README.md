# CLARIAH CMDI Forms
*Tweak Your CMDI Forms to the Max*

This is the home of CCF (CLARIAH CMDI Forms). CCF creates a form in your browser to create or update (meta)data records. These forms are based on the [Component Metadata](http://www.clarin.eu/cmdi/) profiles. However, often these profiles don't contain enough information to create an end user friendly form. To overcome this CCF supports various tweaks, many based on features which have become available in [CMDI 1.2](https://www.clarin.eu/cmdi1.2). CCF is implemented using Python and JavaScript.

:construction: **CLARIAH CMDI Forms is under construction** :construction:

You can already try out this beta version, but please check back to see new features and documentation appear here! And feel free to contact us with any questions by opening an issue!

## Build & Run

You can use [Docker](https://www.docker.com/get-started) to quickly build and run the application:

```sh

docker run -p 1210:1210 --name=ccf --rm -it ghcr.io/knaw-huc/service-huc-editor:2.0-RC5
curl -v -X PUT -H 'Authorization: Bearer foobar' http://localhost:1210/app/HelloWorld

```

Now visit http://localhost:1210/app/HelloWorld in your browser. See https://github.com/knaw-huc/service-huc-editor how to roll your own!

## Modules

* [HuC Editor API Services](https://github.com/knaw-huc/service-huc-editor/) (Python)
* [KNAW HuC Generic Editor](https://github.com/knaw-huc/huc-generic-editor/) (JavaScript)

### Publications, presentations & demonstrations

1. M. Windhouwer. The HuC CMDI editor: What is new? Demonstration at the *[CLARIN Annual Conference](https://www.clarin.eu/event/2024/)*, Barcelona, Spain, October 16, 2024.
2. R. Zeeman, M. Windhouwer. Tweak Your CMDI Forms to the Max. Demonstration at the *[CLARIAH Toogdag](https://www.clariah.nl/en/events/toog-day-2019)*, Hilversum, The Netherlands, April 5, 2019. 
3. R. Zeeman, M. Windhouwer. [Tweak Your CMDI Forms to the Max](https://office.clarin.eu/v/CE-2018-1292-CLARIN2018_ConferenceProceedings.pdf#page=102). Presented at the *[CLARIN Annual Conference](https://www.clarin.eu/event/2018/clarin-annual-conference-2018-pisa-italy)*, Pisa, Italy, October 8-10, 2018.
4. R. Zeeman, M. Windhouwer. Component Metadata & TLA-FLAT. Demonstration at the *[CLARIAH Toogdag](https://www.clariah.nl/evenementen/toog-dag-2018)*. The Hague, The Netherlands, March 9, 2018. 
