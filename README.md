# Collections

Collections serves the GOV.UK navigation pages and organisation pages.

At time of writing, it also serves the priority campaign pages ie:
-  Coronavirus pages
- Transition landing page ([ gov.uk/transition](https://www.gov.uk/transition) )
- DIT landing page ( [gov.uk/eubusiness ](https://www.gov.uk/transition ))

See the [Campaign pages](#campaign-pages) section below for more information.

## Screenshots

### Browse page

![Browse page](docs/browse-page.jpg)

### Topic page

![Topic page](docs/topic-page.jpg)

### Subtopic page

![Subtopic page](docs/subtopic-page.jpg)

### Services and information page

![Services and information page](docs/services-and-information-page.jpg)

### Taxonomy page

![Taxonomy page](docs/taxonomy-page.png)

### Worldwide taxonomy page

![Worldwide taxonomy page](docs/world-taxonomy-page.png)

### Organisation index page

![Organisation index page](docs/orgs-index-page.png)

### Organisation page

![Organisation page](docs/org-page.png)

### Step by step page

![Step by step page](docs/step-by-step-page.png)

## Live examples
- Browse page: [gov.uk/browse](https://www.gov.uk/browse)
- Topic page: [gov.uk/oil-and-gas](https://www.gov.uk/oil-and-gas)
- Subtopic page: [gov.uk/oil-and-gas/fields-and-wells](https://www.gov.uk/oil-and-gas/fields-and-wells)
- Services and information page: [gov.uk/government/organisations/hm-revenue-customs/services-information](https://www.gov.uk/government/organisations/hm-revenue-customs/services-information)
- Taxonomy page: [gov.uk/education](https://www.gov.uk/education)
- Worldwide taxonomy page: [gov.uk/world/japan](https://www.gov.uk/world/japan)
- Organisation index page: [gov.uk/government/organisations](https://www.gov.uk/government/organisations)
- Organisation page: [gov.uk/government/organisations/cabinet-office](https://www.gov.uk/government/organisations/cabinet-office)
- Step by step page: [gov.uk/learn-to-drive-a-car](https://www.gov.uk/learn-to-drive-a-car)

## APIs

The endpoints and known consumers of this application's APIs are documented in [docs/api](docs/api.md)

## Nomenclature

### Topics

- **Curated list**: a group of content tagged to a subtopic that has been
  curated into a named list.
- **Topic**: a named group of sub-topics. (A deprecated name for this is "specialist sector".)
- **Sub-topic**: a group of content within a topic. (A deprecated name for this is
"specialist sub-sector".)

### Browse pages

- **Root browse page**: [gov.uk/browse](https://www.gov.uk/browse)
- **Top level browse page**: [gov.uk/browse/benefits](https://www.gov.uk/browse/benefits)
- **Second level browse page**: [gov.uk/browse/benefits/entitlement](https://www.gov.uk/browse/benefits/entitlement)

### Taxonomy
The taxonomy is surfaced on taxon pages, which group together tagged content for that level of the taxonomy into [supergroups](https://docs.publishing.service.gov.uk/document-types/content_purpose_supergroup.html) on the page, e.g: Guidance and Regulation for Funding and finance for students [gov.uk/education/funding-and-finance-for-students](https://www.gov.uk/education/funding-and-finance-for-students). Each taxon page also shows a grid of sub-topics at the next level of the taxonomy.

### Worldwide taxonomy
The worldwide taxonomy is rendered on different types of pages depending on whether the taxon has any children.

For example:
- **Taxon with children**: a content item of type taxon that has
  `child_taxons` links. None of those child taxons' links have `child_taxons`,
  in which case we display an accordion view:
  [gov.uk/world/afghanistan](https://www.gov.uk/world/afghanistan)
- **Taxon without children**: a content item of type taxon that doesn't have
  `child_taxons` links. In this case we display an leaf view:
  [gov.uk/world/living-in-afghanistan](https://www.gov.uk/world/living-in-afghanistan)
- **Taxon with associated taxons**: a content item of type taxon that has
  `associated_taxons` links. In this case the tagged content of the taxon will
  include content that is directly tagged to it and also content that has been
  tagged to any of the associated taxons.

## Campaign pages

Collections currently renders the following campaign pages:

#### Transition landing page ([ /transition ](https://www.gov.uk/transition))
All content for the transition landing pages are currently read from yaml files. [Welsh](config/locales/cy/transition_landing_page.yml) and [English](config/locales/en/transition_landing_page.yml) translations are available.

#### DIT landing page ([ /eubusiness ](https://www.gov.uk/eubusiness))
All content for the DIT landing pages are currently read from yaml files e.g. for [English](config/locales/en/dit_landing_page.yml). See the [content item's available translations](https://www.gov.uk/api/content/eubusiness) for the current list.

#### Coronavirus pages:
  - Landing page ( [gov.uk/coronavirus](https://www.gov.uk/coronavirus) ),
  - Postcode lookup service( [gov.uk/find-coronavirus-local-restrictions](https://www.gov.uk/find-coronavirus-local-restrictions) )
  - Hub pages ( [/getting-tested-for-coronavirus](https://www.gov.uk/getting-tested-for-coronavirus), [/worker-support](https://www.gov.uk/coronavirus/worker-support), [/business-support](https://www.gov.uk/coronavirus/business-support) and [/education-and-childcare](https://www.gov.uk/coronavirus/education-and-childcare) )

## Technical documentation

This is a public facing Ruby on Rails application that retrieves browse content from APIs and presents it. There is no underlying persistence layer, and (with the exception of the [campaign pages](#campaign-pages)) all content is retrieved from external sources.

### Content for taxon pages

Content for taxon pages is returned by Search API based on content_ids for world taxonomy pages and content_ids and [supergroups](https://docs.publishing.service.gov.uk/document-types/content_purpose_supergroup.html) for all other taxonomy pages.

### Dependencies

- [content-store](https://github.com/alphagov/content-store), provides:
    - Mainstream browse pages (Root, Top and Second level browse pages)
    - Topics
    - Subtopics and their curated lists
- [search api](https://github.com/alphagov/search-api), provides:
    - latest changes for Topics
    - content tagged to a particular Topic, Mainstream browse page or Organisation
- [email-alert-api](https://github.com/alphagov/email-alert-api), provides:
    - support for subscribing to notifications from a topic

### Running the application

- #### With startup scripts

```
./startup.sh
```

The app should start on http://localhost:3070

```
./startup.sh --live
```

This will run the app and point it at the production GOV.UK `content-store` and `static` instances.

```
./startup.sh --dummy
```

This will run the app and point it at the [dummy content store](https://govuk-content-store-examples.herokuapp.com/), which serves the content schema examples and random content.

- #### With govuk-docker

Once you have installed [govuk-docker](https://github.com/alphagov/govuk-docker#installation), do the following
```
> cd govuk/govuk-docker
> git pull origin master
> make collections

> cd govuk/collections
> govuk-docker-up
```

Collections will be running locally at collections.dev.gov.uk.

### Running the test suite

Use `bundle exec rake` to run the test suite, excluding JavaScript. Or if you are running in docker, `govuk-docker-run bundle exec rake`

#### Javascript tests

Use `bundle exec rake jasmine:ci` to run Jasmine tests

## License

[MIT License](LICENCE.txt)
