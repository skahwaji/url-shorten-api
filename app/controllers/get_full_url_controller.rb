class GetFullUrlController < ApplicationController
  def create
    puts("---------------")
    short_url = ShortUrl.find_by(short_code: params[:id])
    puts(short_url.original_url)
    # puts(short_url.original_url)
    puts("---------------")

    redirect_to short_url.original_url, allow_other_host: true
  end
end
