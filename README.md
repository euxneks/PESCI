PESCI
=====

Parser for Electron SCanner Ini files.  Don't think many would use this but I want to start using github.

This is a simple program to go through some special text files used by the electron scanning microscope at UVic to record how
materials or objects were handled in the electron microscope. It allows you to easily see the differing values in a table and
toggle the corresponding rows if you find them insignificant.  If you have any problems or need help with this script, feel
free to contact the author.
 @author: Chris Tooley <euxneks@gmail.com>

License: MIT

Copyright (C) 2013 Chris Tooley <euxneks@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

**Install**
First, install these modules in PERL using cpanm like so:
   $ cpan App::cpanminus
   $ cpanm Config::IniFiles
 This is applicable to at least Mac OS X and Windows with Strawberry Perl.  I haven't tested Linux but if you're a linux user you can probably 
 beat this script into submission yourself.
File::Spec is included with most perl installations I think. Otherwise just install like above.

**Usage**: 
perl pesci.pl [-o <filename>][-w <workdir>][-?]

	--output -o 	:specify the output file. default:./generatedTable.html
	--workdir -w 	:specify the working directory where the INI text files are located. default: ./
	--help -h -? 	:show this help dialog


