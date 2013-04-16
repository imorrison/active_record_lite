require 'uri'

module Params
  def parse(req, pattern)
    # parameter parsing and merging
    path = req.path
    match_data = pattern.match(path)
    
    params = {}

    if match_data.names.length > 0
      match_data.names.each_with_index do |name, i|
        params[name.to_sym] = match_data[i+1]
      end 

      #p params
      params
    end
    params
  end

  def parse_www_encoded_form(str)
    # decode the request body and parse each key according to rails convetion
    body_string = URI.decode_www_form_component(str)
    
    # instead of sending the whole strin use parse_key

    {:test => body_string}
  end

  def parse_key
    # recursivly apply regex (/(?<head>.*)[(?<rest>.*)]/)

  end
end