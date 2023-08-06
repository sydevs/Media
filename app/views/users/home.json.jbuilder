
json.array! %w[hero path boost] do |section|
  json.partial! "users/sections/#{section}"
end
