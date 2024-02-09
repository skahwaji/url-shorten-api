class ShortUrl < ApplicationRecord
    validates_uniqueness_of :short_code # or validates :short_code, unique: true

    def to_s
        "Original URL: #{@original_url}--#{@short_code} )"
    end
end
