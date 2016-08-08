https://github.com/Casecommons/pg_search_documents


Usage

PgSearch.multisearch(search_string)

searches :name items in models [Artist, Song, Album]. 
These which have included pg_search Module


Rebuilding search documents for a given class

NOTE: 
If you change the :against option on a class, add multisearchable to a class that already has records in the database, or remove multisearchable from a class in order to remove it from the index, you will find that the pg_search_documents table could become out-of-sync with the actual records in your other tables.

The index can also become out-of-sync if you ever modify records in a way that does not trigger Active Record callbacks. For instance, the #update_attribute instance method and the .update_all class method both skip callbacks and directly modify the database.

To remove all of the documents for a given class, you can simply delete all of the PgSearch::Document records.
PgSearch::Document.delete_all(:searchable_type => "Animal")

To regenerate the documents for a given class, run:

PgSearch::Multisearch.rebuild(Product)

This is also available as a Rake task, for convenience.

$ rake pg_search:multisearch:rebuild[BlogPost]