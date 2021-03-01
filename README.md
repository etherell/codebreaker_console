# Codebreaker Console

Console part of the codebreaker game. It uses **codebreaker gem** as the logic part and implements DB, validations, and view logic inside.

Here implemented such classes:
1. StatsManager - to sort and save game statistics
2. Validator - for validations
3. Consoles:
⋅⋅* BaseConsole - contains the same logic for all consoles. I implemented all consoles as callable objects
⋅⋅* OptionsConsole - console from which game starts and a player can choose option what he wants to do next
⋅⋅* RegistrationConsole - console where player input data about him and chooses the game difficulty
⋅⋅* GameConsole - a console that shows options for a game: gets player number, the show hits, etc.
⋅⋅* ResultCosole - a console that shows results of the game and proposes next steps for player

# How to start?

1. Copy code
2. Run in console

    $ bundle install

2. Then run

    $ ruby game.rb

