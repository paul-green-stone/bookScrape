# bookScrape 🕷️📚

Simple Web Scraper in Perl for 🔭 Obtaining Books from https://ast.ru/series/luchshaya-mirovaya-klassika-1241886/

As a passionate reader and collector, the sight of a well-stocked bookshelf is a source of comfort and inspiration. There's a magic in the presence of unread books. Absolutely, there's something truly captivating about a wall lined with books, each one representing a world waiting to be explored ... 🗺️ 🗺️ 🗺️

I got a little carried away 😅

## 🛠️ Usage

To use the script, ensure that the following modules are installed: 

- 1️⃣ [Moo](https://metacpan.org/pod/Moo)
- 2️⃣ [Text::CSV](https://metacpan.org/pod/Text::CSV)
- 3️⃣ [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny)
- 4️⃣ [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder)

If your Perl is located in a different directory, you will need to change the shebang located at the first line of the script 'bworm.pl'. You can do this by first invoking `which perl` to determine its location and then using it. After that, you can use the command `chmod 755 bworm.pl` to make the script executable.

An alternative way to use the Perl script is to simply execute the command `perl bworm.pl` in the terminal or command prompt.

### How It Works ❓

The script requests a web page and subsequently parses its content to construct a tree. Then it conducts a targeted search for elements that meet specified criteria, such as in this case, collecting books (a basic understanding of HTML is required).  Upon identifying these elements, the script creates objects and incorporates them into a list for further processing.

Following the initial page processing, the script proceeds to extract information related to pagination links, constructs a new URI, and repeats the entire process until the last page is successfully processed.

Upon completion of the data extraction process, the script generates a CSV (comma-separated value) file that contains the gathered data. For example:

```bash
https://cdn.ast.ru/v2/ASE000000000850257/COVER/cover1__w220.jpg,"Золотой теленок","Ильф Илья Арнольдович"
```
