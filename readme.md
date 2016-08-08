Validations
  Duplicate album/artist combos should not be allowed. 


Site should haveat least one each of 
  an AJAX GET 
  and AJAX POST (or some other modification type verb).

Implement search using pg search











Recordly

Implement Favorites 
Favorites should be a polymorphic model
can input string "album", "song", or "artist", along with associated id 
into the favorites table. 
favorites tables belong to user.
  Duplicate song titles on the same album should not be allowed.
User has many favorites, as: favoritable?

how does thatAPI work for Polymorphic Models


They should be able to "favorite" any 
  album
  song
  artist
  from any album in their collection 
When complete, user should be able to view a list of their "favorite" albums and/or songs, etc.



Recordly will be an application that allows for users to input and store their record collection.
Each user can add a new album and input its data.
  New Album must contain: 
  album name
  artist name (Songs with their titles are optional!)
When complete, the user should be able to view their entire record collection 




The site should have the following functionality:

User login
Search
Views:
  Album Index with artist from each album
  Album Show with songs index from one album
  Artists Index with each artist from user's albums, 
    and albums index from each artist
  Songs Index from all of the user's albums, with album and artist

Favorites Views: User can choose favorite from each of
  Albums
  Artists
  Songs
  for all Albums, Artists, and Songs in their portfolio.

Validations
  Duplicate album/artist combos should not be allowed. 
  Duplicate song titles on the same album should not be allowed. 

please build an application using TESTING and best practices. 
Make the site have a mix of traditional CGI forms with page refreshes
Site should haveat least one each of 
  an AJAX GET 
  and AJAX POST (or some other modification type verb).

Please provide a link for the GitHub repository and deployed url for the application so that we can see the various portions working.

