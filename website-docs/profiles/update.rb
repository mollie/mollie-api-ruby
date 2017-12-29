require 'mollie-api-ruby'

begin
  profile = Mollie::Profile.update(
    "pfl_v9hTwCvYqw",
    name:         "My website name",
    website:      "https://www.mywebsite.com",
    api_key:      'access_Wwvu7egPcJLLJ9Kb7J632x8wJ2zMeJ'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end
