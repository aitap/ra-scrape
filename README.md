# UPDATE: Ra has ended

No updates are planned and an EPUB containing all chapters, the original ending and appendices is available. Go to <https://qntm.org/ra> and download it from there.

# What is this?

This script prepares a EPUB version of qntm's book [Ra](https://qntm.org/ra) by scraping the website.

# Dependencies

 - [perl](https://perl.org) >= 5.13.2 (although could be made to work on older versions)
 - [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) >= 5
 - [Calibre](https://calibre-ebook.com/) (you don't have to start its interface, but you need to be able to run the `ebook-convert` executable)

# How it works

 1. Run `perl ra.pl`
 2. It downloads all chapters it can find, applies minor fixes and joins them in a single file `ra.html`
 3. It then runs `ebook-convert` from Calibre to build `ra.epub` from `ra.html`

# Licensing

While building an e-book from <https://qntm.org/ra> is okay, the resulting `ra.epub` is not redistributable.
