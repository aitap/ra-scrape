# What is this?

This script prepares a EPUB version of qntm's book Ra by scraping the website (sorry about that).

# Dependencies

 - perl >= 5.020 (although could be made to work on older versions)
 - HTML::TreeBuilder >= 5
 - Calibre (you don't have to start its interface, but you need to be able to run the `ebook-convert` executable)

# How it works

 1. Run `perl ra.pl`
 2. It downloads all chapters it can find, applies minor fixes and joins them in a single file `ra.html`
 3. It then runs `ebook-convert` from Calibre to build `ra.epub` from `ra.html`
