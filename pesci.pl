#!/usr/bin/perl
#change the above to match your environment
#pesci.pl ver. 2013-02-07
#
#This is a simple program to go through some special text files used by the electron scanning microscope at UVic to record how
#materials or objects were handled in the electron microscope. It allows you to easily see the differing values in a table and
#toggle the corresponding rows if you find them insignificant.  If you have any problems or need help with this script, feel
#free to contact the author.
# @author: Chris Tooley <euxneks@gmail.com>
#
#License: MIT
#
#Copyright (C) 2013 Chris Tooley <euxneks@gmail.com>
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
#files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
#modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
#Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
#IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#
# To use:
#First, install these modules in PERL using cpanm like so:
#   $ cpan App::cpanminus
#   $ cpanm Config::IniFiles
# This is applicable to at least Mac OS X and Windows (with Strawberry Perl).  I haven't tested Linux but if you're a linux user you can probably 
# beat this script into submission yourself, alternately, contact me and I can help.
# If you have suggestions, by all means please contact me and tell me. I do not claim to be awesome in perl.
#
# File::Spec is included with most perl installations I think. Otherwise just install like above.
#
#Next, simply run the application in a terminal or command prompt like so:
#   $ perl pesci.pl [-o <filename>][-w <workdir>][-?]
#   or, if you have the permissions set to executable, eliminate "perl" in the above command.
#
use Config::IniFiles;
use File::Spec::Functions;
use Getopt::Long;

#get a list of all text files in the current directory, and parse through them, outputting to an HTML file.
$workdir = File::Spec->curdir();
$outputFile = './generatedTable.html';
$help = '';

$result = GetOptions( "output|o=s" => \$outputFile,
						"workdir|w=s" => \$workdir,
						"help|?|h" => \$help);

#to combat windows command prompt ridiculousness - if the specified outputFile is a dir, 
if ( -d $outputFile ) {
    print "Usage error, expected outputFile to be a file, got a directory instead:\n";
    $help = true;
}

if ( -f $workdir ) {
	print "Usage error, expected work directory to be a directory, got a filename instead:\n";
	$help = true;
}

if ( $help ) {
	#show usage and flag options, and what they mean.
	print "pesci.pl (c) 2013 Chris Tooley\nUsage: perl pesci.pl [-o <filename>][-w <workdir>][-?]\n\n\t--output -o \t:specify the output file. default:./generatedTable.html\n\t--workdir -w \t:specify the working directory where the INI text files are located. default: ./\n\t--help -h -? \t:show this help dialog\n\n";
	exit;
}
$workdir = '"' . $workdir . '"';
my @files = glob '' . File::Spec->catfile($workdir, '*.txt') . '';
open( OUTFILE, ">" . $outputFile ); #open for overwrite
print "\nPerl Electron SCanner INI parser...\nWill output to file: " . $outputFile . "\n";
#all value names in the text files. If you add another, add it here, in order, preferably.
my @headers = qw(InstructName SerialNumber DataNumber SampleName Format ImageName Directory Date Time Media DataSize PixelSize SignalName AcceleratingVoltage DecelerationVoltage Magnification WorkingDistance EmissionCurrent LensMode PhotoSize Vacuum MicronMarker SubMagnification SubSignalName SpecimenBias Condencer1 ScanSpeed CalibrationScanSpeed ColorMode ColorPalette ScreenMode Comment KeyWord1 KeyWord2 Condition DataDisplayCombine StageType StagePositionX StagePositionY StagePositionR StagePositionZ StagePositionT);

#defaults here. The order *shouldn't* matter, but if you add another option and it buggers up, try putting it in order.
my @defaults = qw(ImageName Date Time PixelSize AcceleratingVoltage Magnification WorkingDistance EmissionCurrent Condencer1 ScanSpeed CalibrationScanSpeed Condition);

#javascript function has been broken out for easy editing.
# I recommend using chrome or firefox, or any other webkit-based browser (safari, for example)
my $javascript = '<script type="text/javascript">
	function toggleClassDisplay( className, element ){
		var elements = document.getElementsByClassName( className );
		if ( element.style.backgroundColor != \'gray\' ) {
			element.style.backgroundColor = \'gray\';
			element.style.color = \'#111\';
		} else {
			element.style.backgroundColor = \'lightgreen\';
			element.style.color = \'black\';
		}
		for ( var i = 0; i< elements.length; i++ ) {
			if( elements[i].style.display != \'none\'){
				elements[i].style.display = \'none\';
			}else{
				elements[i].style.display = \'\';
			}
		}
	}
</script>';

#VERY SIMPLE NOT AT ALL GOOD HTML.  I don't think it's valid HTML actually, but it will render fine in Chrome and Firefox at least.
print OUTFILE "<html>\n<head>\n$javascript\n<style type=\"text/css\">table{border-collapse:collapse}td{border:1px solid black;padding:2pt;}th{background:lightgray;border:1px solid black;}</style>\n</head>\n<body>\n";

#these are the interactive components that allow the viewer to choose which columns to hide/show
my $numperrow = 8;
my $count = 0;
print OUTFILE "<table><tr>";
foreach $header (@headers){
	if ( $count > $numperrow ) {
		print OUTFILE "</tr><tr>";
		$count = 0;
	}
	print OUTFILE "<td id=\"_$header\" style=\"background-color:gray;color:#111;cursor:pointer;\" onclick=\"toggleClassDisplay('$header', this)\">$header</td>\n";
	$count++;
}
print OUTFILE "</tr><table> <br />";

#one use flag
my $headers_made=0;


#generate the table here, given the above headers.
#by default, everything is not-displayed, and unhidden with the toggle javascript function
#below this foreach loop.
foreach $filekey ( keys @files ){
	print "Processing " . $files[$filekey] . "\n";
	my %cfg;
	tie %cfg, 'Config::IniFiles', ( -file=>$files[$filekey] );
	print OUTFILE "<tr>\n";
	if ( $headers_made != 1 ) {
		#only want to run this once.
		foreach $key (@headers){
			print OUTFILE "\t<th class=\"$key\" style=\"display:none;\">$key</th>\n"
		}
		print OUTFILE "</tr>\n";
		print OUTFILE "<tr>\n";
		$headers_made = 1;
	}
	foreach $key (@headers){
		print OUTFILE "\t<td class=\"$key\" style=\"display:none;\">$cfg{'SemImageFile'}{$key}</td>\n"
	}
	print OUTFILE "</tr>\n"
}
print OUTFILE "\n<script type=\"text/javascript\">";

#unhide the defaults with the javascript toggle function we already have.
foreach $default ( keys @defaults){
	print OUTFILE "\ntoggleClassDisplay('$defaults[$default]', document.getElementById('_$defaults[$default]'));"
}
print OUTFILE "\n</script>";
print OUTFILE "\n</table>\n</body>\n</html>";
print "Done\n";
#general cleanup.
close(OUTFILE);

