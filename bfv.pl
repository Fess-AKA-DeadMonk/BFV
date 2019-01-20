#!/usr/bin/env perl
use feature say;

# input file
my $file = "bfv.input";

# output file
my $csv = "bfv.csv";
open( FILE, "<", "$file" ) or die "can not open $file";
open( CSV,  ">", "$csv" )  or die "can not open $csv";

my $table = {};
my ($weapon_number);
READ: while ( my $string = <FILE> ) {
    chomp $string;
    my ( $prop_name, $prop_val );

    # remove empty strings
    if ( $string =~ /^\s*$/ ) {
        next READ;
    }

    # next weapon
    elsif ( $string =~ /^\w/ ) {
        $weapon_number++;
        $prop_name = 'Weapon Name';
        $prop_val  = $string;
    }

    # weapon property
    else {
        $string =~ /^\s+([^:]+):(.*)/;
        $prop_name = $1;
        $prop_val  = $2;
    }
    $table->{$prop_name} = [] if !( $table->{$prop_name} );
    $table->{$prop_name}->[$weapon_number] = $prop_val;
}

say CSV join "\t", sort { $b cmp $a } keys %$table;
WRITE: for ( my $i = 0 ; $i < $weapon_number ; $i++ ) {
    foreach my $key ( sort { $b cmp $a } keys %$table ) {
        print CSV $table->{$key}->[$i], "\t";
    }
    print CSV "\n";
}
