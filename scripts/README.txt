sqleet helper scripts
=====================

This folder contains interactive helper scripts for encrypting and decrypting
SQLite .db files with sqleet.exe.

Files
-----

encrypt-db.bat
Encrypt one database file.

decrypt-db.bat
Decrypt one encrypted database file.

encrypt-folder.bat
Encrypt all .db files in one folder.

decrypt-folder.bat
Decrypt all .db files in one folder.

Usage
-----

Run any .bat file by double-clicking it, or from a terminal:

  encrypt-db.bat
  decrypt-db.bat
  encrypt-folder.bat
  decrypt-folder.bat

The scripts will prompt for:

  - input file path or folder path
  - output file path when using single-file mode
  - password

Naming rules
------------

Single-file mode:

  - you choose the output file path yourself

Folder mode:

  - encryption output: originalname_enc.db
  - decryption output: originalname_dec.db

Examples:

  data.db      -> data_enc.db
  data_enc.db  -> data_dec.db

Notes
-----

  - single-file mode overwrites output files automatically if they already exist
  - source files are not modified
  - folder mode does not require a specific source file name pattern
  - folder mode skips a source file when its corresponding target file already exists
