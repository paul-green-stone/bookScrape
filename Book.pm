package Book;

use Moo;

# ================================================================ # 

has 'image'  => (is => 'ro');		# Book cover image
has 'title'  => (is => 'ro');		# Book title
has 'author' => (is => 'ro');		# Book author

# ================================================================ # 

1;
