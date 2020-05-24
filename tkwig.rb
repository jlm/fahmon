#
# This program uses RubyTk widgets to put up a window showing my Folding@Home score and rank.
#
# Resources:
#     https://tkdocs.com/tutorial/index.html
#     https://phpandmore.net/2012/03/10/ruby-tk-events-timers/
#     https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
#
require 'tk'
require 'tkextlib/tile'
require 'open-uri'
require 'json'
require 'byebug'

root = TkRoot.new {title "Folding score"}

#
# Root frame
#
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( :sticky => 'nsew')
TkGrid.columnconfigure root, 0, :weight => 1; TkGrid.rowconfigure root, 0, :weight => 1

###########################
### Row 1
###########################

#
# The text label for the Folding score
#
Tk::Tile::Label.new(content) {text 'Your score is'}.grid( :column => 1, :row => 1, :sticky => 'e')

#
# A Font
#
AppHighlightFont = TkFont.new :family => 'Helvetica', :size => 24, :weight => 'bold'

#
# Folding score variable
#
$foldscore = TkVariable.new
Tk::Tile::Label.new(content) {textvariable $foldscore; font AppHighlightFont}.grid( :column => 2, :row => 1, :sticky => 'we');

###########################
### Row 2
###########################

#
# The text label for the Rank
#
Tk::Tile::Label.new(content) {text 'Your rank is'}.grid( :column => 1, :row => 2, :sticky => 'e')

#
# Rank variable
#
$rank = TkVariable.new
Tk::Tile::Label.new(content) {textvariable $rank; font AppHighlightFont}.grid( :column => 2, :row => 2, :sticky => 'we');

###########################
### Row 3
###########################

#
# The text label for the Status
#
Tk::Tile::Label.new(content) {text 'Status'}.grid( :column => 1, :row => 3, :sticky => 'e')

#
# Status variable
#
$fstatus = TkVariable.new
Tk::Tile::Label.new(content) {textvariable $fstatus}.grid( :column => 2, :row => 3, :sticky => 'we');

#
# A button
#
f = Tk::Tile::Button.new(content) {text 'Update'; command {getscore}}.grid( :column => 3, :row => 3, :sticky => 'w')


#
# Set stuff up
#
TkWinfo.children(content).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}
f.focus
root.bind("Return") {incscore}

#
# Initialise the display variables
#

$foldscore.value = 'Unknown'
$rank.value = 0
$fstatus.value = 'Unknown'

#
# Fetch the folding score from the API
#
def getscore
    begin
      scores = JSON.parse(URI.open('https://stats.foldingathome.org/api/donors?name=John_Messenger&search_type=exact').read())
      results = scores['results'][0]
      $foldscore.value = results['credit']
      $rank.value = results['rank']
    rescue => e
      puts e.message
      $foldscore.value = ''
      $rank.value = ''
    end
    begin
      statii = JSON.parse(URI.open('http://127.0.0.1:7396/ping').read().gsub(/'/, '"'))
      puts "statii is #{statii.inspect}"
      $fstatus.value = statii['version']
    rescue => ee
      puts ee.message
      $fstatus.value = 'Not folding'
    end
end

#
# A little routine for debugging
#
def incscore
  begin
    $foldscore.value = $foldscore + 1
  rescue
    $foldscore.value = ''
  end
end

#
# A timer to update the score every 60k milliseconed
#
timproc = proc { puts 'The timer went off'; getscore }
TkTimer.new(60 * 1000, -1, timproc).start()

#
# Let's do this.
#
Tk.mainloop
