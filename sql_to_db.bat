copy /Y Elements.db Elements.db.bak
del Elements.db
..\..\Plug\sqlite3.exe Elements.db <Elements.sql