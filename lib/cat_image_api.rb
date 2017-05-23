module CatImageAPI
  require 'rest-client'
  require 'colorize'
  extend self

  REG = /src\s*=\s*"([^"]*)"/

  PARAMS = {
    format: "html",
    results_per_page: 1,
    type: 'png,jpg, gif',
    size: 'med, full'
  }


  def get_image
    response = RestClient.get(ENV["CAT_API_URL"], params: PARAMS)
    if result = REG.match(response.body)
       puts "GET image from cat api #{result[1]} ".green
       result[1]
    end
  rescue  => e
    puts e.inspect.red
    nil
  end
end
