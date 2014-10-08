# Kate's Recipes

## Overview

### What is this?

While learning Ruby I did [Jumpstart Lab's EventManager project](http://tutorials.jumpstartlab.com/projects/eventmanager.html), which was a nice little intro to building a Ruby application that uses data in a CSV file and making HTML files using ERB. But it didn't have a whole lot of data types and didn't do a whole lot _with_ that data. 

I wanted to learn more and push myself with this newfound knowledge so I thought about what has a bunch of data of different types that can be manipulated in different ways and I thought of recipes! So I built this little program that stores recipes in a CSV, builds HTML pages from that data, allows the user to add new recipes and to search recipes based on ingredients, create a shopping list of ingredients from multiple recipes and modify ingredient amounts based on how many batches of the recipe you want to make. 

It's not a fancy program, it has a handful of limitations and the user interface isn't that great, but the point of this exercise was to expand on the Ruby knowledge I learned while doing the EventManager project, not create a program fit for public distribution.

Sample Recipe page:

![Sample Recipe](/img/sample_recipe_screenshot.jpg)

### What it does

- Display a list of recipes in an `index.html` page.
- Allow user to add recipes through the terminal window.
- Display each recipe on its own HMTL page. 
- Displays which recipes user can make based on required ingredients (if any) or excluded ingredients (if any).
- Creates a shopping list compiling all the ingredients from multiple recipes
- Modifies ingredient amounts based on how many batches of a certain recipe the user wants to make.

### Contents

- `css/style.css` - Styling for the recipe pages
- `data/recipe_database.csv` - Spreadsheet of all the recipes. A few recipes have already been added
- `img/` - Folder holding all the photos for the recipes
- `lib/` - Folder holding all the Ruby files that make this program go
	- `add_recipe.rb` - Adds a new recipe to the csv file
	- `create_recipe_pages.rb` - Turns data in spreadsheet into HTML files for the user to browse
	- `create_shopping_list.rb` - Asks user which recipes they want to make a shopping list from then compiles the ingredients
	- `multiply_recipe.rb` - Multiplies (or divides) the ingredients in a recipe depending on how many batches of it the user wants to make
	- `search_recipes.rb` - Asks the user which ingredients they want to search for and which ingredients they want to exclude and displays recipes that include and exclude those ingredients
- `recipe_pages/` - Folder holding all the HTML files for each individual recipe
- `templates/` - Folder holding the ERB templates for making different pages
	- `index_template.erb` - Template for the `index.html` page when new recipes are added
	- `recipe_template.erb` - Template for each individual recipe
	- `search_template.erb` - Template for the `search.html` page that is created when a user searches for recipes
- `.gitignore` - .gitignore file. You can ignore this
- `index.html` - Front page of program. Includes the recipes already added to csv
- `README.md` - This file you're reading
- `search.html` - An existing `search.html` file. This gets overwritten every time user does a new search

## How to Use 

### Getting Started

- **Download program** to the folder of your choice

### Usage

**View Recipes**

Easily see all the recipes you have entered.

- Double click on `index.html` file so it opens in your browser. Ta da! Here's a list of all the recipes in the CSV file.
- Click on a recipe to go to its page. The sidebar of each recipe has all the other recipes listed by category, so it's easy to jump between recipes

**Add Recipe**

Have a new recipe you love and want to add it to your compilation of recipes?

- Navigate your terminal window to the project's folder
- Type `ruby lib/add_recipe.rb` and hit enter
- Terminal window will ask you all kinds of questions about your recipe. When it comes to the ingredients, it will ask whether the ingredient is _required_. For example, cilantro is fun on tacos, but isn't **required** to make them. Taco shells, however, probably are.
- When done, the program will add the info to the CSV spreadsheet, create a new `index.html` page listing your new recipe, create that recipe's own HTML page, and open `index.html` so you can begin browsing recipes. 

**Search Based on Ingredients**

Do you have ground beef you want to use up but no sour cream? What can you make?? Enter that info into the program and it will find all recipes requiring ground beef that require sour cream. Maybe your Tacos recipe includes sour cream as an _optional_ ingredient - if so, Tacos will still show up as a recipe you can make, since sour cream is _optional_. Pretty cool!

- Navigate your terminal window to the project's folder
- Type `ruby lib/search_recipes.rb` and hit enter
- The program will list all the ingredients you have in all your recipes for easy reference and ask you which ingredients you want to require. 
	- If none, just type `q` and hit enter. 
	- Otherwise, type your required ingredient like `Flour`, hit enter, type another ingredient and hit enter and keep going until you're done and type `q`
- Repeat the process for excluded ingredients. 
- The program will find all the recipes that satisfy your requirements, create a new `search.html` file listing those recipes and open it in your browser. 
- Look through that list of recipes and click on the one you want to make!

**Shopping List**

Want to make two batches of zucchini bread and one batch of Turkey Noodle Casserole? Need to know all the ingredients to buy?

- Navigate your terminal window to the project's folder
- Type `ruby lib/create_shopping_list.rb` and hit enter
- The program will list all the recipes you have stored and ask which ones you want to compile a shopping list for like such:

```
~~~~~~~~~~~~~~~~~~~~~~~~~
Hello! Here are all your recipes
1. Secondhand Turkey
2. Turkey Noodle Casserole
3. Wasabi Beef Fajitas
4. Green Smoothie
5. Zucchini Bread
6. Fried Zucchini
~~~~~~~~~~~~~~~~~~~~~~~~~
Which recipes would you like to make a shopping list from?
Just enter their numbers separated by commas.
For instance, if you want to make
two batches of recipe 3 and 
one batch of recipe 1, enter: 
3, 3, 1
~~~~~~~~~~~~~~~~~~~~~~~~~
```

- For our example above of two batches of zucchini bread and one of Turkey Noodle Casserole, you'd enter `5, 5, 2` and hit enter. 
- As if by magic you'll be shown all the ingredients you need to buy. If one recipe required 2 TBSP of butter and the other required 4 TBSP butter, you'd be told to buy 6 TBSP butter. Voila!

**Multiply/Divide Ingredients**

Does your recipe serve 4, but you need to serve 6? Does it make two loaves but you only have ingredients for 1? I can't tell you how many times I have started a recipe and had in my head that I was doubling it and forgotten halfway through. Oops. It would have been nice to see the ingredients all already adjusted! This does just that. 

- Navigate your terminal window to the project's folder
- Type `ruby lib/multiply_recipe.rb` and hit enter
- - The program will list all the recipes you have stored and ask which one you want to multiply divide, like so:

```
~~~~~~~~~~~~~~~~~~~~~~
Here are all your recipes for your reference
1: Secondhand Turkey
2: Turkey Noodle Casserole
3: Wasabi Beef Fajitas
4: Green Smoothie
5: Zucchini Bread
6: Fried Zucchini
~~~~~~~~~~~~~~~~~~~~~~
Does your recipe serve 4 but you need to serve 6?
Does it make 2 loaves but you only have ingredients for 1?
This program will multiply (or divide!) the ingredients in your recipes!
Choose from one of the recipes above to get started.
To pick the second recipe enter the number 2.
```

- Enter which recipe by its number. Say we want to make half a batch of Zucchini bread so type `5` and hit enter
- The program will ask how much you want to multiply or divide by. Since we want to make half a loaf, type `.5` and hit enter
- Up will pop all the ingredients divided in half for your reference.

### Limitations and Known Issues

Okay, the program has some shortcomings, but the point was to stretch my new Ruby skills and CSV exposure wherever my imagination took them, not to create a perfect program. 

For instance, I wouldn't want to input data through a terminal window, I'd build a nice form on a php page and instead of adding each ingredient by hand I'd display the ingredients in a drop down menu. Humans are fallible. Computers are literal. "Ground beef" is not the same as a misspelled "Gruond beef". "Eggs" are not the same as "Egg". A

lso, if I'm creating a shopping list and one recipe calls for 2 tbsps of milk and another calls for 1 cup of milk and another for 1/2 cup of milk, my shopping will tell me to buy 1.5 cups of milk and 2 tbsps of milk. This is an easy fix with math, converting all the various inputs so the program can say to buy 1.6 cups of milk (or whatever 1.5 cups plus 2 tbsps is) but again, that's missing the point of the exercise. 

You also can't edit/delete the recipes, but again, the point of the program...

I'm sure there are plenty of other issues. I'm sure there are ways to break the program, or things you could enter into the CSV that would damage it, but it was a fun project and great practice. 

## Developer Info

This program was written by me, Kate McFaul. Visit me at [KateMcFaul.com](http://katemcfaul.com). To reiterate, this was a fun project and a great learning experience in Ruby, not an exercise in making a perfect program to distribute to the masses!
