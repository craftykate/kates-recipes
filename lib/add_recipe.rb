require 'csv'

contents = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol


# Get how many recipes there are and add two to get the index of the next recipe
contents.each_with_index do |row, i|	
	@i = i+2
end

puts "Enter name of recipe"
name = gets.chomp

# The "link" name for the recipe is the name in all lowercase, joined by "_". 
link = name.downcase.split.join("_")

puts "Enter recipe source"
rec_source = gets.chomp

puts "Enter how many it serves (4, 1 loaf, etc)"
serve = gets.chomp
# Set to nil if nothing was entered
serve = nil if serve == ""

puts "Enter category (Dinner, Bread, etc)"
rec_cat = gets.chomp

puts "Enter rating"
rating = gets.chomp.to_i
rating = nil if rating == ""

puts "Enter baking temp (press return if not valid)"
bake_temp = gets.chomp
bake_temp = nil if bake_temp == ""

puts "How long to bake? (press return if not valid)"
bake_for = gets.chomp
bake_for = nil if bake_for == ""

puts "At least one ingredient is required. After all, what's a recipe with no ingredients??"
ingredients = Hash.new
loop do
	puts "Enter an ingredient (q to quit)"
	i_name = gets.chomp

	# If user enters q or a blank line move on. 
	break if i_name.downcase == "q"
	break if i_name == ""

	puts "Sometimes ingredients are nice to have, but not required. Cilantro makes a taco better, but you don't NEED it to make tacos."
	puts "Is this ingredient required? (y/n)"
	i_req = gets.chomp
	i_req.downcase == "y" ? i_req = 1 : i_req = 0

	puts "How many units? (\"0.5\" for 1/2, etc.)"
	puts "(Cups, lbs, etc will come next)"
	i_amount = gets.chomp.to_f

	puts "What are the units? (Singular please: cup, lb, each, etc)"
	i_unit = gets.chomp.to_sym

	puts "Any directions? (Minced, thawed, etc. Press return if not.)"
	i_dir = gets.chomp
	i_dir = nil if i_dir == ""

	# Store each ingredient in the ingredients hash
	ingredients[i_name] = [i_req, i_amount, i_unit, i_dir]
end

# Later the code will split the directions on each ** to make a new paragraph
puts "Enter directions. (Start new paragraph with 2 asterisks: \"**\".)"
directions = gets.chomp

puts "Enter image name (Like: tacos.jpeg - Press return if no image.)"
puts "(If you have an image put it in the img folder)"
image_loc = gets.chomp
image_loc = nil if image_loc == ""

# Push all info for the recipe into the csv
CSV.open("data/recipe_database.csv", "a") do |csv|
  csv << [@i, name, link, rec_source, serve, rec_cat, rating, bake_temp, bake_for, ingredients, directions, image_loc]
end

puts "Thank you. Your recipe has been added."

# This launches the program that creates the individual pages for the recipes
system("ruby lib/create_recipe_pages.rb")
