class Movie < ApplicationRecord
    before_validation :parse_image    
    # belongs_to :production_company
    
    has_and_belongs_to_many :tags
    has_and_belongs_to_many :genres
    has_many :movie_casts
    has_many :cast_members, through: :movie_casts
    has_many :awards, through: :movie_casts
    has_many :wishers, through: :watchlists, source: :users
    has_many :ratings
    has_many :recommendations
    
    has_attached_file :Poster, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :Poster, content_type: /\Aimage\/.*\z/
    attr_accessor :poster_base

    def Genres
        ret = ""
        self.genres.each{|genre| ret += "#{genre.name}, "}
        return ret.chomp(", ");
    end

    private
        def parse_image
            byebug
            image = Paperclip.io_adapters.for(poster_base)
            image.original_filename = "poster.jpg"
            self.Poster = image;
        end

end