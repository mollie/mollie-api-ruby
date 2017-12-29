require 'mollie-api-ruby'

begin
  profile = Mollie::Profile.get(
    "pfl_v9hTwCvYqw",
    api_key: 'access_Wwvu7egPcJLLJ9Kb7J632x8wJ2zMeJ'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end
