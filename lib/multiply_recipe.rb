require 'csv'
require 'erb'

contents = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol

# Store all recipe info in all_recipes hash
all_recipes = []
contents.each do |row|	
	all_recipes << row
end

puts "~~~~~~~~~~~~~~~~~~~~~~"
puts "Here are all your recipes for your reference"
all_recipes.each { |r| puts "#{r[0]}: #{r[1]}"}
puts "~~~~~~~~~~~~~~~~~~~~~~"
puts "Does your recipe serve 4 but you need to serve 6?"
puts "Does it make 2 loaves but you only have ingredients for 1?"
puts "This program will multiply (or divide!) the ingredients in your recipes!"
puts "Choose from one of the recipes above to get started."
puts "To pick the second recipe enter the number 2."
recipe = gets.chomp.to_i
puts "And how much do you want to multiply the ingredients?"
puts "Enter 0.5 to halve, 2 to double, etc."
amount = gets.chomp.to_f
puts "~~~~~~~~~~~~~~~~~~~~~~"
# Pick just the recipe the user chose
puts all_recipes[recipe-1][1]
puts "Ingredients * #{amount}"
puts "~~~~~~~~~~~~~~~~~~~~~~"

# Store ingredients for that recipe in the ingredients hash
ingredients = []
# Pull out just the ingredients
ingredients = eval(all_recipes[recipe-1][9])
# Multiply the ingredient by the amount the user specified
ingredients.each do |k,v|
	puts "#{v[1] * amount} #{v[2]} #{k}"
end