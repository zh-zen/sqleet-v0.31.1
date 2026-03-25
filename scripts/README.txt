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
Encrypt all eligible .db files in one folder.

decrypt-folder.bat
Decrypt all eligible *_enc.db files in one folder.

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

  - output files are overwritten automatically if they already exist
  - source files are not modified
  - folder mode skips files already ending with _enc or _dec during encryption
