#!/usr/bin/perl
use 5.020;
use warnings;
use autodie;
use URI;
use HTML::TreeBuilder 5 -weak;

open my $html, ">:utf8", 'ra.html';
binmode STDOUT, ":utf8";

my $url = 'https://qntm.org/ra';
# keep a reference to the root of the tree
my $idx = HTML::TreeBuilder::->new_from_url($url);

# make the chapter structure make sense
say $html HTML::Element::->new_from_lol(['a', { name => 'ra' }])->as_HTML;
say $html HTML::Element::->new_from_lol(['h1', 'Ra'])->as_HTML;

for my $item ($idx->look_down(_tag => 'div', id => 'content')->look_down(sub { $_[0]->tag =~ /^(h[34]|a)$/i })) {
	if ($item->tag eq 'h3') {
		if ($item->attr('id') eq 'sec0') { next } # skip "contents"
		else { last } # stop once we've reached something else
	} elsif ($item->tag eq 'h4') {
		$item->tag('h1');
		say $html $item->as_HTML;
	} else { # must be a link
		say STDERR $item->as_trimmed_text, " ", $item->attr('href');
		# allow anchor-linking between chapters
		say $html HTML::Element::->new_from_lol(['a', { name => $item->attr('href') =~ s/[^a-z]//gr }])->as_HTML;
		say $html HTML::Element::->new_from_lol(['h2', $item->as_trimmed_text])->as_HTML;

		# must keep this root, too
		my $ch = HTML::TreeBuilder::->new_from_url(URI::->new_abs($item->attr('href'), $url));

		my $chapter = $ch->look_down(_tag => "div", id => "content");
		# remove links to previous/next chapter
		for (($chapter->content_list)[0,-1]) {
			$_->delete if ($_->tag eq 'h4' and $_->look_down(_tag => 'a'));
		}
		for ($chapter->look_down(_tag => 'a')) { # the file contains some more links
			if (defined URI::->new($_->attr('href'))->authority) { # it seems to point to a different server
				$_->replace_with($_->as_trimmed_text)
			} else { # may be a book chapter
				$_->attr('href' => "#". ($_->attr('href') =~ s/[^a-z]//gr));
			}
		}

		say $html $chapter->as_HTML;
	}
}

$html->flush();

exec qw(ebook-convert ra.html ra.epub --title=Ra --authors=qntm --language=en --input-encoding=utf8 --max-levels=0 --no-default-epub-cover), q{--chapter=//*[(name()='h1' or name()='h2')]}, q{--level1-toc=//*[name()='h1']}, q{--level2-toc=//*[name()='h2']}, q{--level3-toc=//*[name()='h3']};
