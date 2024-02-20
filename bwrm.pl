#!/usr/local/bin/perl

use lib './';		# Add a directory to search for a module at runtime
use open qw( :std :encoding(UTF-8) );

# ================================ # 

use Book;

use HTTP::Tiny;
use HTML::TreeBuilder;
use Text::CSV;
use Encode;

# ================================ #

# An array of all the books
my @books = ();				

# Initialize the list of pages to scrape
my @pages_to_scrape = ('https://ast.ru/series/luchshaya-mirovaya-klassika-1241886/?PAGEN_1=9');

# Initializing the list of pages discovered
my @pages_discovered = ($pages_to_scrape[0]);

# Base URL used to construct absolute URLs
my $base_url = 'https://ast.ru/series/luchshaya-mirovaya-klassika-1241886/?PAGEN_1=';

# ================ #  

# Initialize the HTTP client
my $http = HTTP::Tiny->new();

# Initialize the HTML Tree Builder
my $tree = HTML::TreeBuilder->new();

# ================================================================ #

while (@pages_to_scrape) {

	# Get the current page to scrape by popping it from the list	
	my $current_page = pop @pages_to_scrape;

	print "Scraping $current_page\n";
	
	# Retrieve the HTML code of the page to scrape
	my $response = $http->get($current_page);

	# Decode the content since it contains Russian characters
	my $html_content = decode('UTF-8', $response->{content});

	# Construct a HTML tree
	$tree->parse($html_content);

	# ================================ # 
		
	# Look for the elements satisfying the given criteria on the page that has just been received
	my @raw_books = $tree->look_down('_tag', 'div', class => qr/^card__box-body$/);

	foreach (@raw_books) {

		my $image = $_->look_down('_tag', 'img')->attr('src');
		my $title = $_->look_down('_tag', 'a', class => qr/card__title/)->as_text;
		my $author = $_->look_down('_tag', 'p', class => qr/card__text/)->as_text;

		# Create a new Book object
		my $book = Book->new(image => $image, title => $title, author => $author);
		
		# Add a book to the list
		push @books, $book unless (in($book, @books));
	}
	
	# Retrieve the list of pagination URLs
	my @list_elms = $tree->look_down('_tag', 'li', class => qr/^pagination__link-block$/);
	my @new_pagination_links = map { sprintf "https://ast.ru/series/luchshaya-mirovaya-klassika-1241886/?PAGEN_1=%d", $_->look_down('_tag', 'a', class => 'pagination__link')->as_text } @list_elms;

	foreach my $new_link (@new_pagination_links) {
		# If the page discovered is new
		unless (grep { $_ eq $new_link } @pages_discovered) {
			push @pages_discovered, $new_link;

			
			# If the page discovered needs to be scraped
			unless (grep { $_ eq $new_link } @pages_to_scrape) {
				push @pages_to_scrape, $new_link;
			}
		}
	}
	
	print "...\n";
	
	# Sleeping for a second
	sleep(1);
}

# ================================================================ #

# Create a CSV file and write the header
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, eol => $/ });

# Define the header row of the CSV file
my @csv_headers = qw(image title author);

open my $file, '>:encoding(UTF-8)', 'books.csv'
	or die "Failed to create 'books.csv': $!";

$csv->print($file, \@csv_headers);

# ================================ #

# Populate the CSV file
foreach my $book (@books) {
	my @row = map { $book->$_ } @csv_headers;	

	$csv->print($file, \@row);
}

close $file;

# ================================================================ # 

sub in {
	my ($element, @array) = @_;

	foreach  (@array) {
		if ($element->{image} eq $_->{image} && $element->{title} eq $_->{title} && $element->{author} eq $_->{author}) { return 1; }
	}

	return 0;
}
