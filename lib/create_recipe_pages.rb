require "csv"
require "erb"

contents = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol

# I ran into unknown problems when I tried to use the above "contents" variable for a second call to contents. Adding a second variable fixed it. An issue to figure out later.
# FYI, I did later figure out the issue. But didn't feel like rewriting all the code!
@contents1 = CSV.open "data/recipe_database.csv", headers: true, header_converters: :symbol

# Ingredients are stored as a hash in one of the columns. 
# This steps through the hash in the ingredients column to pull out info in a readable manner
def display_ingredients(ingredients)
	# "eval" turns the hash string back into a proper hash
	ingredients = eval(ingredients)
	# Push the ingredients into a table that will go into the recipe page
	ingredients.map do |key, value|
		"<tr><td>#{value[1]}</td>  <td>#{value[2]}</td> <td>#{key}#{(", " + value[3]) if value[3] != nil}</td></tr>"
	end
end

# Pulls all recipe names (and their links, id's and categories) to list them in the sidebar and search pages
def list_all_recipes
	@all_recipes = []
	@contents1.each do |row|
		@all_recipes << [row[:name], row[:link], row[0], row[:category], row[:source], row[:rating]]
	end
	@all_recipes
end

# Sorts all recipe names in a variable sorted by category, then by name
# This is for displaying them all in order in the sidebar, organized by category
each_recipe = list_all_recipes.sort_by{ |i| [i[3], i[0]] }

# Saves all info about a recipe into its own file
def save_recipes(id, link, recipe_page)
	# Makes the recipes directory if there isn't one
	Dir.mkdir("recipe_pages") unless Dir.exists? "recipe_pages"

	# names the file: link_name_id.html so there are no duplicates, regardless if two recipes are named "Pasta"
	filename = "recipe_pages/#{link}_#{id}.html"

	# Opens the file and saves (actually rewrites) the recipe info
	File.open(filename, 'w') do |file|
		file.puts recipe_page
	end
end

puts "~~~~~~~~~~~~~~~~~~~"
puts "Building recipes..."

# Store the recipe page template in a variable
recipe_template = File.read "templates/recipe_template.erb"
# Start a new ERB
erb_template = ERB.new recipe_template

# Go through the contents of the csv file row by row to create recipe page
contents.each do |row|
	id = row[0]
	name = row[:name]
	link = row[:link]
	source = row[:source]
	serves = row[:serves]
	category = row[:category]
	rating = row[:rating]
	bake_temp = row[:bake_temp]
	bake_for = row[:bake_for]
	ingredients = display_ingredients(row[:ingredients])
	directions = row[:directions]
	image_loc = row[:image_name]

	recipe_page = erb_template.result(binding)

	puts "Building #{row[:name]}"

	# Calls the method to write the page
	save_recipes(id, link, recipe_page) 
end

puts "Building recipes is done."
puts "~~~~~~~~~~~~~~~~~~~"

puts "Building index page..."

# Creates or rewrites the index page
def create_index(index_page)
	# names the file
	filename = "index.html"

	# Opens the file and saves the info
	File.open(filename, 'w') do |file|
		file.puts index_page
	end
end

# Store the index page template in a variable
index_template = File.read "templates/index_template.erb"
# Start a new ERB
erb_template_index = ERB.new index_template
index_page = erb_template_index.result(binding)
# Calls the method to build the index page
create_index(index_page) 
puts "Building index page is done."
puts "~~~~~~~~~~~~~~~~~~~"
# Opens our newly created index page!
system("open index.html")
