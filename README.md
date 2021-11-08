# theScore "the Rush" Interview Challenge
At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?
In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack
As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/priv/repo/rushing.json).

##### Challenge Requirements
1. Create a web app. This must be able to do the following steps
    1. Create a webpage which displays a table with the contents of [`rushing.json`](/priv/repo/rushing.json)
    2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
    3. The user should be able to filter by the player's name
    4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
    
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution
1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help
If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.

### Installation and running this solution
... TODO

## A brief discussion about the solution

Note: I didn't used Docker for this project because I just started using a macbook, and for some reason
I'm having problems to setup docker with phoenix on macbook. I'm sorry for that.
Phoenix 1.6 is easier to setup locally since it's not using node_modules, so at least it should be straightforward
to run the application without docker as well.

I'll describe some of the design decisions and steps for creating this solution.
It's kind verbose but I hope it will help.

TL;DR It works.

### First Step
I have decided to create a PlayerRegistrationController to act as an anti-corruption layer.
That's because I'm not familiar with Football, so reading "Lng", "TD" and "Att/G" was a bit obscure.

I defined a contract that parses each field into a longer named attribute.
I also have included an extra attribute which is "longest_rush_is_touchdown", so I could get rid of the "T" letter
and turn the Lng field into an integer for easier sorting later.

I did a process of data validation to analyse the provided data to see if any other fields
would have a bitstring where a numeric value was expected.

To extract all fields that have at least one value as bitstring, do:

```elixir
json = File.read!("priv/repo/rushing.json") |> Jason.decode!()

Enum.zip(json)
|> Enum.map(fn x -> Tuple.to_list(x) end)
|> Enum.map(fn list -> Enum.filter(list, fn tuple -> is_bitstring(elem(tuple, 1)) end) end)
|> Enum.filter(fn list -> list != [] end)
|> Enum.map(fn [head | tail] -> head end)
|> Enum.map(fn tuple -> elem(tuple, 0) end)
```

I would never be able to read this code again later, so for future reference, from the first enum to the last pipe:

1. Transform the list of maps into a list of tuples using zip, each tuple is a collection of attributes
2. It's hard to iterate on tuples, so transform each tuple into a list, you'll have a list of lists
3. Filter each sublist to delete everything that isn't a bitstring
4. Remove the empty sublists
5. Keep the head of each sublist
6. Collect the name of each field that contains at least one bitstring as a value

The result is:
```elixir
["Lng", "Player", "Pos", "Team", "Yds"]
```

So, I created two functions to parse and validate the fields "Lng" and "Yds".

The result is a very easy and elegant (I think) function.

```elixir
 def player_from_json(data) do
    data
    |> Json.json_to_map
    |> apply_contract(get_contract_player_from_json)
    |> validate_player
 end

 defp validate_player(%{} = map) do
    map
    |> parse_longest_rush()
    |> parse_total_yards()
 end
```

If I want to inspect a specific field, such as "Avg", I can do the following:

```elixir
json = File.read!("priv/repo/rushing.json") |> Jason.decode!()

Enum.zip(json)
|> Enum.map(fn x -> Tuple.to_list(x) end)
|> Enum.map(fn list -> Enum.filter(list, fn tuple -> elem(tuple, 0) == "Avg" end) end)
|> Enum.filter(fn list -> list != [] end)
```

The steps are the same except for the third, where I filter all tuples for the field "Avg".

I have created a module to wrap those functions to help visualize and validate the data.
The module can be found on `lib/rush/data_analysis.ex` to help on explore the data and ensure validation.

```elixir
iex(1)> data = Rush.DataAnalysis.data_collection_from_file("priv/repo/rushing.json")
...
iex(2)> Rush.DataAnalysis.find_type(data, &is_bitstring/1)
["Lng", "Player", "Pos", "Team", "Yds"]
iex(3)> Rush.DataAnalysis.explore_field(data, "Avg")
[
   {"Avg", 3.5},
   {"Avg", 1},
   {"Avg", 2},
   {"Avg", 0.5},
...
```

With a valid data persisted in the database, we can start working on the requirements.

### Second Step

The second step consisted of developing the front-end application and designing the events to match the requirements.

I was using the most common architecture design for working with LiveView, which is pretty much,
forget MVC and your LiveView do almost everything but business logic.

After a while I decided to refactor the code and I started using the LiveView main file only as a "View".
Inside the live folder, you'll find a "index.ex", which is the Live`View` file, and a "index_controller.ex" where
I extracted all the helper functions and logic that was not the handle_params/3 and handle_event/3 functions.

Then I've created one live component for each needed component.
The live component helps into testing the view, and it also helps organizing the code
applying the single-responsibility principle, although you increase the number of files to handle.

I wrote tests for each live component, and I've wrote some documentations.
About this, not all code is documented, and the documentations was more about explaining how I organized the files
and some design decisions as well.
I've tried to write code as DRY as I could, and I've tried to create façades,
small functions and utilize the MVC design pattern as much as I could as LiveView kinds of advocate the opposite.

All events patches the url, so you can also manipulate params directly and share "state" to other users.
The sorting isn't cumulative, if you sort Yds, you "order_by" Yds only.
Filter is strict, it start filtering from the third typed character,
but you can enable fuzzy filtering. Try `?filter=fuzzy`.

I've found this table design searching about Tailwind tables. I liked it very much and stole it for us.
I put this little boy picture as a placeholder from where I stole this "circle picture" code,
I thought it would be cool to show the Team logo or wordmark in the future,
could be consuming an API or holding the images as assets. Alternatively we could use the players
pictures as well.

The design is responsive, on a "small" and "medium" display the table will receive a scroll.
Note that "small" isn't mobile.
I've taken a design decision that I'm not sure if it was a good idea, but since it's only a prototype, I think it's ok:
On mobile, which is a screen smaller than the Tailwind "small" attribute, we start omitting table columns.
I'm not familiar with Football, so I'm not sure which columns would be "more important" so it was kind arbitrary.
However if you turn the phone horizontally and you'll have the entire table available.

The front-end was tested on Safari, Firefox, Chrome and Chrome mobile (Android Phone).

### Third Step

After losing some time trying to discover the best approach to handle a file to the user with LiveView,
I decided to use a link and establish a GET route.

I created three possible ways of handling the file, but used only one.
The other two are available in the controller with some comments (and ideas about using them).

The download function was tested on all three major browsers as well as Android, it works sending the user to do a get request
passing the parameters (filters, sort orders) in a new tab, so LiveView will not lose connection.
