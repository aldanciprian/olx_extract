#!/usr/bin/perl

use List::MoreUtils qw(uniq);

my $first_url = "https://www.olx.ro/imobiliare/apartamente-garsoniere-de-vanzare/2-camere/timisoara/?search%5Bfilter_float_price%3Afrom%5D=50000&search%5Bfilter_float_price%3Ato%5D=70000&search%5Bprivate_business%5D=private";
my @output = `lynx -dump "$first_url"`;
my $next_url="";

my @oferta_array;

do
{

$next_url = "";
foreach (@output)
{
   chomp($_);
  
	#print "[$_]\n";
	
	if ( $_ =~ /.* \[(\d*)\]Urmatoarele anunturi.*/ )
	{
		$next_url =  $1;
	}
	if ( $_ =~ /.*(https.*oferta.*)[^promoted]$/ )
	{
		push @oferta_array, $1;
	}
	if ( $next_url != "" )
	{
		if ( $_ =~ /.*$next_url.*(https.*)$/ )
		{
			$next_url = $1;
		}
	}
}

print " next url is $next_url \n";

if  ( $next_url ne "" )
{
	@output = `lynx -dump "$next_url"`;
}


} while ($next_url ne  "" );

my @uniq_oferta_arrays =  uniq(@oferta_array);

foreach (@uniq_oferta_arrays)
{
	local $apt = $_;
	print "getting $apt \n";
	@output=`lynx -dump $apt`;	
	my $start = 0;	
	foreach (@output)
	{
		chomp($_);
		#print "[$_]\n";
		if ( $start == 1 )
		{
			print $_."\n";
			if ( $_ =~ /.*Urmatorul anunt.*/ )
			{
#				print $_."\n";
				$start = 0;
				last;
			}
		}
		
		if ( $start == 0 )
		{
			if ( $_ =~ /.*Oferit de.*/ )
			{
				#print $_."\n";
				$start = 1;
			}
		}
	}
}

