#!/usr/bin/perl
#
#
# unsetForceBoot.pl	Lab Manager Light unset Force Boot
#
# Authors:	
# GSS		Schlomo Schapiro <lml@schlomo.schapiro.org>
# 
# Copyright:	Schlomo Schapiro, Immobilien Scout GmbH
# License:	GNU General Public License, see http://www.gnu.org/licenses/gpl.txt for full text
#
#

use strict;
use warnings;


# place DLLs and PMs with the required subdirectory structure into lib/ next to this script
use FindBin;
use lib "$FindBin::RealBin/lib";

use CGI ':standard';
use LML::Common;
use LML::Subversion;
use LML::VMware;
use LML::DHCP;

# connect to vSphere
connect_vi();

# input parameter, UUID of a VM
my $search_uuid=param('uuid')?lc(param('uuid')):lc($ARGV[0]);

die "No forceboot_field parameter set in [vsphere] section" unless (exists($CONFIG{vsphere}{forceboot_field}) and $CONFIG{vsphere}{forceboot_field});

if ($search_uuid) {
    print header('text/plain');
    setVmCustomValueU($search_uuid,$CONFIG{vsphere}{forceboot_field},"");
} else {
    print header(-status=>404,-type=>'text/plain');
    print "Give UUID address as query parameter 'uuid' or as command line parameter\n";
}
