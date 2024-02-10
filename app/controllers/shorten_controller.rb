class ShortenController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "password"

  def create
    original_url = params[:long_url]
    short_url = generate_short_url
    ShortUrl.create(original_url: original_url, short_code: short_url)
    render json: { short_url: request.host_with_port + "/" + short_url }
  end

  private

  def generate_short_url
    # Generate a random 6-character string for the short URL
    chars = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    short_url = (0...5).map { chars[rand(chars.length)] }.join
    # Check if the short URL already exists
    ShortUrl.exists?(short_code: short_url) ? generate_short_url : short_url
  end
end