module Cas
  class Setup
    def install
      ActiveRecord::Base.transaction do
        config = YAML.load_file(filename)

        config["sites"].each do |site_slug, site_config|
          site = ::Cas::Site.where(slug: site_slug).first_or_create
          site.update!(
            domains: site_config["domains"],
            name: site_config["name"]
          )

          site_config["sections"].each do |key, section|
            model = ::Cas::Section.where(
              slug: key,
              site_id: site.id
            ).first_or_create!(
              name: section["name"],
              section_type: section["type"],
            )

            model.update!(
              name: section["name"],
              section_type: section["type"],
            )
          end
        end

        if superadmins_emails_or_logins = config["config"]["superadmins"]
          updated_users = []
          superadmins_emails_or_logins.each do |email_or_login|
            user = ::Cas::User.where(
              'cas_users.email = :value OR cas_users.login = :value',
              value: email_or_login
            ).first

            if user.present?
              unless updated_users.include?(user.id)
                user.update!(sites: ::Cas::Site.all)
              end
              updated_users << user.id
            end
          end
        end
      end
    end

    private

    def filename
      if Rails.env.test?
        "spec/fixtures/cas.yml"
      else
        "cas.yml"
      end
    end
  end
end

