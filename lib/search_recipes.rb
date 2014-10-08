require 'csv'
require 'erb'

contents = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol

# I found it handy to see all the ingredients that I use so I can pick some out for this program
# This array holds all the ingredients
list_ingredients = []
# An array to hold all recipe info
all_recipes = []
contents.each do |row|	
	all_recipes << row
	# turn the string into a hash, push each recipe name into the array
	eval(row[:ingredients]).each do |key, value|
		list_ingredients << key
	end
end

# Sort all the recipes by category then name
all_recipes = all_recipes.sort_by{ |i| [i[5], i[1]] }

puts "~~~~~~~~~~~~~~~~~~~~~~"
puts "Here are all your ingredients for your reference: "
puts list_ingredients.uniq.sort.join(', ')
puts "~~~~~~~~~~~~~~~~~~~~~~"
puts "This program will let you search for recipes that include ingredients, AND exclude recipes that require something you may not have."
puts "" 
puts "For instance, say you have ground beef, but you DON'T have flour or cilantro. Okay, no worries. We'll find all the recipes you can make that include ground beef, but don't require flour or cilantro."
puts "~~~~~~~~~~~~~~~~~~~~~~"
puts "Please list the first ingredient you'd like to REQUIRE."
puts "(Press return or type q if none.)"

# Store all required ingredients
required_ingredients = []
loop do
	ing = gets.chomp

	break if ing.downcase == "q"
	break if ing == ""

	# Change them to downcase for more accurate matching
	required_ingredients << ing.downcase if ing != ""

	puts "Enter another ingredient to REQUIRE."
	puts "(Press return or type q to move on)"
end
puts "Now list any ingredients you want to EXCLUDE."
puts "(Press return or type q if none.)"

# Store all ingredients to exclude
excluded_ingredients = []
loop do
	exl = gets.chomp

	break if exl.downcase == "q"
	break if exl == ""

	# Change them to downcase for more accurate matching
	excluded_ingredients << exl.downcase if exl != ""

	puts "Enter another ingredient to EXCLUDE."
	puts "(Press return or type q to move on)"
end

# Set each to nil if nothing was entered
required_ingredients = nil if required_ingredients == [""]
excluded_ingredients = nil if excluded_ingredients == [""]
# The recipe_summary holds the relevant info about each recipe so we can see if it meets our criteria
recipe_summary = []
# This holds the recipes that satisfy the INCLUDE criteria
satisfied_recipes_incl = []
# This holds the recipes that satisfy the EXCLUDE criteria.
# We will match the two next.
satisfied_recipes_excl = []

# Step through each recipe
all_recipes.each do |recipe|
	# Turn that string hash of ingredients into something we can search through and work with
	recipe_ingredients = []
	ingredients_array = []
	recipe_ingredients = eval(recipe[:ingredients])
	recipe_ingredients.each do |k,v|
		ingredients_array << [k, v[0]]
	end
	recipe_summary << [recipe[:name], ingredients_array, recipe[:link], recipe[0], recipe[:source], recipe[:rating], recipe[:category]]
end

# Step through our nicely set up recipe array
recipe_summary.each do |recipe|
	# This is our "checking" variable to see if we've satisfied our requirements
	all_good = 0
	# Array for all ingredients of the recipe
	all_ing = []
	# Array for required ingredients of the recipe
	req_ing = []

	# Okay, there's a difference in those two arrays above. If I want to cook with ground beef I need to search ALL INGREDIENTS of a recipe to see if ground beef is included.
	# If I don't want to cook with sour cream I just need to see if sour cream is a REQUIRED INGREDIENT in the recipe. Maybe it's not required for Tacos, so Tacos is still an option, even though Tacos includes sour cream. Maybe it IS required for beef stroganoff so beef stroganoff is now NOT an option. 
	# That's why the two variables are needed. I'm not just making more work for myself!

	# Add any ingredient in a recipe to the all ingredient variable
	recipe[1].each do |ing|
		all_ing << ing[0].downcase 
	end

	# Add only the required ingredients in a recipe to the required ingredient variable
	recipe[1].each do |ing|
		req_ing << ing[0].downcase if ing[1] == 1
	end

	# If user entered ingredients to require...
	if required_ingredients != nil
		# reset checking variable
		all_good = 0
		# Step through each required ingredient
		required_ingredients.each do |ing|
			# Increase checking variable if the recipe includes the required ingredient
			all_good += 1 if all_ing.include?(ing)
		end
		# The array of recipes that satisfies the required criteria is now pushed all the relevant info if our checking variable has determined that we have the right number of required ingredients (all of them)
		satisfied_recipes_incl << [recipe[0], recipe[2], recipe[3], recipe[4], recipe[5], recipe[6]] if all_good == required_ingredients.count
	else
		# User did not enter any ingredients to require, therefor all recipes should be added to the array
		satisfied_recipes_incl << [recipe[0], recipe[2], recipe[3], recipe[4], recipe[5], recipe[6]]
	end

	# If user entered ingredients to exclude...
	if excluded_ingredients != nil
		# reset checking variable
		all_good = 0
		# Step through each excluded ingredient
		excluded_ingredients.each do |ing|
			# Increase checking variable if the recipe does NOT include the excluded ingredient
			all_good += 1 if !req_ing.include?(ing)
		end
		# The array of recipes that satisfies the excluded criteria is now pushed all the relevant info if our checking variable has determined that we do NOT have ANY of the excluded ingredients
		satisfied_recipes_excl << [recipe[0], recipe[2], recipe[3], recipe[4], recipe[5], recipe[6]] if all_good == excluded_ingredients.count
	else
		# User did not enter any ingredients to exclude, therefor all recipes should be added to the array
		satisfied_recipes_excl << [recipe[0], recipe[2], recipe[3], recipe[4], recipe[5], recipe[6]]
	end
end

# This array hold our final list of which recipes satisfy both criteria
satisfied_recipes = []
# Go through the include recipes array
satisfied_recipes_incl.each do |recipe|
	# Push each recipe into the final array if it's also on the exclude list
	satisfied_recipes << recipe if satisfied_recipes_excl.include?(recipe)
end

# Create our search page
def make_search_page(search_page)
	# Name is search.html 
	filename = "search.html"

	# Rewrite the search page with our new info
	File.open(filename, 'w') do |file|
		file.puts search_page
	end
end

# Use the search template
search_template = File.read "templates/search_template.erb"
# Start a new ERB
erb_template_search = ERB.new search_template

search_page = erb_template_search.result(binding)

# Call the function that makes the search page
make_search_page(search_page)

# Open our new search page!
system("open search.html")