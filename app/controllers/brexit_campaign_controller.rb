class BrexitCampaignController < ApplicationController
  def show
    @campaign = Campaign.find!("/prepare-eu-exit")
    setup_content_item_and_navigation_helpers(@campaign)

    presenter = BrexitTaxonsPresenter.new
    @taxons = presenter.featured_taxons
    @other_taxons = presenter.other_taxons

    @campaign_links = campaign_links

    render :show, locals: {
      campaign: @campaign
    }
  end

private

  def campaign_links
    {
      section_title: "There's different guidance if you're:",
      contents_list_links: [
        { text: "running a business", href: "/business-uk-leaving-eu" },
        { text: "a UK national living in the EU", href: "/uk-nationals-living-eu" },
        { text: "an EU national living in the UK", href: "/staying-uk-eu-citizen" },
      ]
    }
  end
end
