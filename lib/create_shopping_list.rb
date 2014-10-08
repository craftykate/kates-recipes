require 'csv'
require 'erb'

contents = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol

all_recipes = []
contents.each do |row|	
	all_recipes << row
end

puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "Hello! Here are all your recipes"
all_recipes.each do |recipe| 
	puts "#{recipe[0]}. #{recipe[1]}"
end
puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "Which recipes would you like to make a shopping list from?"
puts "Just enter their numbers separated by commas."
puts "For instance, if you want to make"
puts "two batches of recipe 3 and "
puts "one batch of recipe 1, enter: "
puts "3, 3, 1"
puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
recipes = gets.chomp
# The gsub/split wouldn't work if there wasn't a space or a split
# So I added them in here. Hacky workaround, but whatever.
recipes = recipes + ", "
# Turn entry into an array
recipes = recipes.gsub!(" ","").split(",")

# Holds all our final ingredients
all_ingredients = []
# Step through each recipe number given...
recipes.each do |recipe_num|
	# Step through each recipe...
	all_recipes.each do |r|
		# If the recipe is the same one as the number given...
		if r[0] == recipe_num
			# Push the ingredients as an array into our ingredients array
			eval(r[9]).each do |k,v|
				all_ingredients << [k, v]
			end
		end
	end
end

# Here's where the magic happens. Say we had two recipes above, one required 1/2 cup milk, the other 1 cup milk. As it stands you're going to be told to buy 1/2 cup milk and 1 cup milk. 
# By turning the array into a hash we can add them together! Now you're told to buy 1.5 cup milk. 
shopping_hash = Hash.new(0)
# Go through each ingredient we need to buy
all_ingredients.each do |r|
	# Set the name as "Milk**cup" or "Milk**tbsp"
	# We don't want to add tbsps and cups together (1 cup plus 1 tbsp is not 2 cups...)
	# So we make them different
	name = "#{r[0]}**(#{r[1][2]})"
	# If the ingredient hasn't been added yet
	if shopping_hash[name] == 0
		# Milk**cup = [1, cup]
		shopping_hash[name] = [r[1][1], r[1][2]]
	else
		# Otherwise, if Milk**cup HAS been added, we increase the value
		shopping_hash[name][0] += r[1][1]
	end
end

# We want the shopping list in an array, not a hash, so we can sort it
shopping_list = []
# Go through each item in the hash
shopping_hash.each do |item, amount|
	# Chop off the "**cup" part of "Milk**cup"
	item_name = item.split("**")[0]
	# Milk**cup is now ["Milk", 1, cup]
	shopping_list << [item_name, amount[0], amount[1]]
end

# Sort the list
shopping_list = shopping_list.sort

puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
puts "Here's your shopping list!"
shopping_list.each do |item|
	puts "#{item[0]}: #{item[1]} #{item[2]}"
end
puts "~~~~~~~~~~~~~~~~~~~~~~~~~"