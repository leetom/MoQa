#!/usr/bin/perl
#
# OK, this file can be deleted


open (FILE, '>', 'image.bmp'); 
binmode (FILE); 
print FILE &bmpNum (&myrand(9999)); 
close (FILE); 

sub bmpNum{ 
    my $verifynum=shift; 
    local @n0 = ("3c","66","66","66","66","66","66","66","66","3c"); 
    local @n1 = ("1c","0c","0c","0c","0c","0c","0c","0c","1c","0c"); 
    local @n2 = ("7e","60","60","30","18","0c","06","06","66","3c"); 
    local @n3 = ("3c","66","06","06","06","1c","06","06","66","3c"); 
    local @n4 = ("1e","0c","7e","4c","2c","2c","1c","1c","0c","0c"); 
    local @n5 = ("3c","66","06","06","06","7c","60","60","60","7e"); 
    local @n6 = ("3c","66","66","66","66","7c","60","60","30","1c"); 
    local @n7 = ("30","30","18","18","0c","0c","06","06","66","7e"); 
    local @n8 = ("3c","66","66","66","66","3c","66","66","66","3c"); 
    local @n9 = ("38","0c","06","06","3e","66","66","66","66","3c"); 

    for (my $i = 0; $i < 10; $i++){ 
        for (1 .. 6){ 
            my $a1 = substr("012", int(myrand(3)), 1) . substr("012345", int(myrand(6)), 1); 
            my $a2 = substr("012345",int(myrand(6)),1) . substr("0123", int(myrand(4)), 1); 
            int(myrand(2)) eq 1 ? push(@{"n$i"}, $a1) : unshift(@{"n$i"},$a1); 
            int(myrand(2)) eq 0 ? push(@{"n$i"}, $a1) : unshift(@{"n$i"},$a2); 
        } 
    } 

    my @bitmap = (); 

    for (my $i = 0; $i < 20; $i++){ 
        for (my $j = 0; $j < 4; $j++){ 
            my $n = substr($verifynum, $j, 1); 
            my $bytes = ${"n$n"}[$i]; 
            my $a = int(myrand(15)); 
            $a eq 1 ? $bytes =~ s/9/8/g : $a eq 3 ? $bytes =~ s/c/e/g : $a eq 6 ? $bytes =~ s/3/b/g : $a eq 8 ? $bytes =~ s/8/9/g : $a eq 0 ? $bytes =~ s/e/f/g : 1; 
            push(@bitmap, $bytes); 
        } 
    } 
    for ($i = 0; $i < 8; $i++){ 
        my $a = substr("012", int(myrand(3)), 1) . substr("012345", int(myrand(6)), 1); 
        unshift(@bitmap, $a); 
        push(@bitmap, $a); 
    } 

    my $image = '424d9e000000000000003e0000002800'; 
    $image .= "00002000000018000000010001000000"; 
    $image .= "00006000000000000000000000000000"; 
    $image .= "00000000000000000000FFFFFF00"; 
    $image .= join('', @bitmap); 
    $image = pack ('H*', $image); 

    return $image; 
} 

sub myrand { 
    my $max = shift; 
    my $result; 
    my $randseed = $LBCGI::randseed ; 
    $max ||= 1; 
    eval("\$result = rand($max);"); 
    return $result unless ($@); 
    $randseed = time unless ($randseed); 
    my $x = 0xffffffff; 
    $x++; 
    $randseed *= 134775813; 
    $randseed++; 
    $randseed %= $x; 
    return $randseed * $max / $x; 
} 
