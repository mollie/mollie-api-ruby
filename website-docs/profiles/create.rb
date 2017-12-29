require 'mollie-api-ruby'

begin
  profile = Mollie::Profile.create(
    name:         "My website name",
    website:      "https://www.mywebsite.com",
    email:        "info@mywebsite.com",
    phone:        "31123456789",
    categoryCode: "5399",
    mode:         "live",
    api_key:     'access_Wwvu7egPcJLLJ9Kb7J632x8wJ2zMeJ'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end
