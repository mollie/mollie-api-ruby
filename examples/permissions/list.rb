require 'mollie-api-ruby'

begin
  limit       = 50
  permissions = Mollie::Permission.all(
    limit: limit,
    api_key: 'access_Wwvu7egPcJLLJ9Kb7J632x8wJ2zMeJ'
  )
rescue Mollie::Exception => e
  puts 'An error has occurred: ' << e.message
end
