## NFL Rushing

We have some stats from the players of the NFL and the idea here is to show these data, with the possibility to filter by the player name and sort based on some stats:

- Yds: Total Rushing Yards (The default ordination)
- TD: Total Touchdowns
- Lng: Longest Rush (The ball represents a touchdown scored)

In addition to the orderable stats, we can change the direction too (asc and desc), we just need to click on the column to change it.

Besides that, we can export the data to a CSV
Note: We can export the filters to the CSV too, so, we can filter the player name, change the ordination, and export these results to the CSV.

## Installation and running this solution

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `npm install` inside the `assets` directory
* Start Phoenix endpoint with `mix phx.server`

Visit [`localhost:4000`](http://localhost:4000) from your browser.

## Decisions

### Architecture

I started the app thinking split it into two systems: front (React) and backend (Phoenix/Elixir). I have chosen it because it would be close to the theScore stack, so, in my first commits, I've put a [SYSTEM] tag to identify the commits related to the backend, and after I would put a [APP] tag to identify the commits related to the frontend. But, this is my first Phoenix/Elixir app, divided it in front and back would be more complex to me, so I've talked with the people team to ask if it's okay  I only create a Phoenix App instead of a stack similar to you.

The application has two endpoints:

`/` - The main page of the application, where all players are listed and we could filter by name and/or order the players ascending or descending.

`/players.csv` - The endpoint that returns the players in a CSV file. The endpoint cares about the filter and ordination did by the user.

As I haven't a directive to follow, I opt to set the Total Yards as the default ordination, desc as the default direction, and "clear"   the offset when the user changes the direction or the ordination. But, I see it as a product decision, and if it was a real product I would ask the Product Manager or someone with this role to decide how to implement it.

### How does the app create the players?

For now, the only way to create a player is by reading the file `rushing.json`. I've created a module on `seeds.exs` that handles the JSON file and transforms the raw data in registers in the database. In addition, I opt to use the full name in the database schema to improve the readability (I believe total_touchdown is more readable than TD).

### Pagination

I opt to create a simple pagination by myself, but a lib like Scrivener/ScrivenerEcto is useful to this problem, I just decide not to use it to not create another external dependency. 

### Dependencies

Beyond the Phoenix dependencies, I've added three more deps:

* [Credo](https://github.com/rrrene/credo): To help me with good practices.

* [CSV](https://github.com/beatrichartz/csv): This deps helped me to create the CSV file with more facility because I can define a header to the file, pass a map with the headers as keys and the lib do the job to create the rows. 

* [Floki](https://github.com/philss/floki): This deps helped me to create more assertive tests related to the visualized content. 
With it I can check part of HTML content using CSS selectors.

* [Ex-Machina](https://github.com/thoughtbot/ex_machina): To help with the data creation for the tests.

### Possible Improvements

The idea in this section is just to talk about some situations that I faced and bring them to you know about it and maybe change if make sense :smile:

* Change the params map to a struct.

* Two queries on PlayerController: one to count the registers and the other to fetch the data.
I'm not satisfied with this solution for this case, but I believe this is the best that I can do for this scenario (maybe Ecto.Multi?).
Note: We need to count the total registers to create the pagination link.
