# Movies

Training project (Ruby)

This is a library for work with information about Top-250 movies. The library provides:
* show information by movie (producer, actors, release date, genres etc.)
* filter movies by attribute (genre, release year, country)
* show statistic by genre, producer or release month
* create virtual cinema with flexible filters
* render movie list to HTML
* parse information from TMDB and IMDB (posters, titles, budgets)

To start type in a project directory:
```
$ bin/demo.rb <database_path (optional)>
```

To parse information from TMDB:
```
$ bin/tmdb_parser.rb
```
**Important!** Don't forget to create `.env` file in root directory with your API key. Get your API key [here](https://www.themoviedb.org/account)

To parse information from IMDB:
```
$ bin/imdb_parser.rb
```

This info will be saved in `data` directory

Example of cinema:
```
$ bin/netflix.rb --pay 100 --show genre:Action,country:USA
```
