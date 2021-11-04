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

### First Step
I have decided to create a PlayerRegistrationController to act as an anti-corruption layer.
That's because I'm not familiar with Football, so reading "Lng", "TD" and "Att/G" was a bit obscure.

I defined a contract that parses each field into a longer named attribute.
I also have included an extra attribute which is "longest_rush_is_touchdown", so I could get rid of the "T" letter
and turn the Lng field into an integer for easier sorting later.

I did a process of data validation to analyse the provided data to see if any other fields
could have a bitstring where a numeric value was expected.

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
