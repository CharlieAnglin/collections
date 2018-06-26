module Organisations
  class PeoplePresenter
    include OrganisationHelper
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
    end

    def all_people
      @org.all_people.map do |person_type, people|
        {
          title: I18n.t('organisations.people.' + person_type.to_s),
          people: handle_duplicate_roles(people, person_type)
        }
      end
    end

  private

    def handle_duplicate_roles(people, person_type)
      all_people = []

      people && people.each do |person|
        person_multiple_roles = all_people.select do |all_people_item|
          all_people_item[:heading_text] === person["name"]
        end

        if person_multiple_roles.empty?
          all_people.push(formatted_person_data(person, person_type))
        else
          all_people.map do |all_people_item|
            if all_people_item[:heading_text].eql?(person_multiple_roles.first[:heading_text])
              if is_person_ministerial?(person_type)
                all_people_item[:extra_links] = multiple_role_links(all_people_item, person)
              else
                all_people_item[:description] = multiple_role_description(all_people_item, person)
              end
            end
          end
        end
      end

      all_people
    end

    def multiple_role_links(existing_person_info, new_person_info)
      existing_role_links = existing_person_info[:extra_links]
      new_role_links = [
        {
          text: new_person_info["role"],
          href: new_person_info["role_href"]
        }
      ]

      existing_role_links.concat(new_role_links)
    end

    def multiple_role_description(existing_person_info, new_person_info)
      existing_role_description = existing_person_info[:description]
      new_role_description = new_person_info["role"]

      existing_role_description + ', ' + new_role_description
    end

    def is_person_ministerial?(type)
      type.eql?(:ministers)
    end

    def formatted_person_data(person, type)
      data = {
        brand: @org.brand,
        href: person["href"],
        description: (person["role"] unless is_person_ministerial?(type)),
        metadata: person["payment_type"],
        context: person["name_prefix"],
        heading_text: person["name"],
        heading_level: 3,
        extra_links_no_indent: true
      }

      if is_person_ministerial?(type)
        data[:extra_links] = [{
          text: person["role"],
          href: person["role_href"]
        }]
      end

      if person["image"]
        data[:image_src] = image_url_by_size(person["image"]["url"], 465)
        data[:image_alt] = person["image"]["alt_text"]
      end

      data
    end
  end
end
