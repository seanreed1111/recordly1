User should be able to "favorite" any 
  album, song, or artist from any album in their collection 

When complete, user should be able to view 
a list of their "favorite" albums, artists, and songs, etc.


!User can SEARCH *through* *their* *collection* for any prefix or word

user can add a new album and input its data
    New Album must contain: 
      !album name
      artist name (Songs with their titles are optional!)

User can click on an album to see 
    Artist on the Album, with link to the Artists other work
    Songs on the Album, with no further links except BACK


General User views
Views:
  Album Index with artist from each album
  Album Show with songs index from one album
  Artists Index with each artist from user's albums, 
    and albums index from each artist
  Songs Index from all of the user's albums, with album and artist

Implement restrictions below directly in DB and rescue error
  Duplicate album/artist combos should not be allowed.
  Duplicate song titles on the same album should not be allowed. 

Site should have at least one each of 
  an AJAX GET 
  and AJAX POST (or some other modification type verb).

