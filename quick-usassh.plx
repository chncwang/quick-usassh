#!/usr/bin/perl

use 5.014;
use autodie;

my $time_file = "/tmp/quick-usassh-time.txt";
my $MAX = 10000;

sub serverAddress {
    return "s@_[0].usassh.com"
}

sub pingBestServer {
    my $min = $MAX;
    my $min_num;

    foreach (1..22) {
        if ($_ == 17) {
            next;
        }
        my $address = &serverAddress($_);
        my $cmd = "ping $address | head -n2 > $time_file &";
        system $cmd;
        sleep 1;

        my $line = `head -n2 $time_file | tail -n1`;
        if ($line == "") {
            next;
        } elsif ($line =~ /time=(\d+)/) {
            if ($1 < $min) {
                $min = $1;
                $min_num = $_;
            }
        } else {
            die;
        }
    }

    if ($min == $MAX) {
        die;
    } else {
        return $min_num;
    }
}

my $best_server = &serverAddress(&pingBestServer);
system "pkill ping";

say $best_server;

sub killUsassh {
    my $process = `ps ax | grep user4844\@s | head -n1`;
    if ($process =~ /^(\d+)/) {
        system "kill $1";
    }
}

&killUsassh;

my $cmd = "ssh -qNfx -D 7070 user4844\@$best_server -p 443 -Z usassh";
say "$cmd...";
system $cmd;

exit 0;
