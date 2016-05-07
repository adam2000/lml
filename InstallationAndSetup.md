

# Introduction #

Lab Manager Light has been developed on Ubuntu 10.04 LTS. The following instructions apply to that platform, please see for yourself how to adapt the paths to other Linux distros.

Basically LML could also run on Windows, I just did not try it out.

# Preparation #

To make use of Lab Manager Light one needs the following ingredients:
  * One or more VMware ESX servers managed through a vCenter
  * A dedicated network for Virtual Machines that will be managed by LML
  * A dedicated DNS domain for this network
  * A (virtual) server to host DHCP, TFTP, DNS and HTTP servers preferably on the dedicated network. Other setups are possible but beyond the scope of this guide.

# Installation #

LML requires the following Packages:
  * libsvn-perl
  * libconfig-inifiles-perl
  * [vSphere SDK for Perl](http://www.vmware.com/support/developer/viperltoolkit/)

The following services need to be configured for LML to work properly:
  1. DHCP server
  1. TFTP server
  1. DNS server
  1. HTTP server
  1. VMware vCenter server

## DHCP & TFTP ##
Since LML manages a DHCP server one should first start by setting up the DHCP server to manage the lab network and the TFTP server to provide the [gpxelinux.0](http://syslinux.zytor.com/wiki/index.php/Download) boot image:
  * All systems on the lab network should be able to PXE boot
  * Assign a dynamic range that is large enough for the expected amount of VM

LML will create and maintain a file with all the host entries for the VMs that LML manages. By default the file is at `/etc/dhcp3/dhcp-hosts.conf`, this can be changed in `/etc/lml.conf`. After modifying the file LML needs to restart (or notify) the DHCP server, the command for doing this is also set in `/etc/lml.conf`.

## DNS ##
LML uses the DHCP server to update the DNS server, so the next step is to configure the DHCP-DNS update mechanism. Check the [dhcpd.conf(5)](http://linux.die.net/man/5/dhcpd.conf) man page or search for a guide, like [this one for example](http://www.randombugs.com/linux/linux-isc-dhcp-server-dynamic-dns-updates-debian-ubuntu.html).

## HTTP ##

The LML scripts work as CGI scripts and are access via the HTTP server. The `web/conf.d` directory contains a suitable configuration snippet for the Apache HTTP server. The content of the `web/www` directory should go to the docroot of the HTTP server.

LML uses a data dir to store internal state information. The default location is `/var/lib/lml` but this can be changed in `/etc/lml.conf`. The data dir must be writeable by the user that the CGI scripts run as, for Ubuntu this is `www-data`.

You must create the data dir manually and set the permissions accordingly.

## vCenter server ##

LML needs read-only access rights for the managed VMs and optionally the right to edit the advanced options of the VMs. If you don't want LML to force all VMs to always boot off the network then read-only access is sufficient. Typically one creates a new vCenter role, e.g. "Lab Manager Light Service" with the following permissions:
  * Virtual Machine -> Configuration -> Advanced (for changing the advanced options and force VMs into network boot)
  * Global -> Set custom attribute (not yet used by LML, would allow LML to give feedback to the user via custom attributes)
Create a service user and assign this service user with the LML service role either at the top of the vCenter tree or at the appropriate VM folders.

## Configure LML ##

Copy the `etc/lml.conf` to `/etc/lml.conf` and adjust the settings to match your environment. Take a look at the example configuration in [/etc/lml.conf](http://code.google.com/p/lml/source/browse/etc/lml.conf). In general most settings can be safely disabled by commenting them out. LML should complain if an essential setting is missing.

It is possible to start with the example configuration with the following exceptions:
  * Fill in the `[vsphere]` section, especially the data for the service account. If you don't want to check VM owner or expiration then disable the corresponding `*_field` values in this section.
  * Set the lab DNS domain in the `[dhcp]` and optionally the `[vsphere]` sections
  * Edit the `[hostrules]` section to match your host rules or disable hostname validation. For starters disabling the pattern matching might help if the VMs don't follow an easy naming convention.
  * Edit the `[subversion]` section and remove the settings unless you have a SVN where you want LML to manage hostname entries.

Copy the `etc/cron.d/lab-manager-light` cron job definition to `/etc/cron.d` and adjust to your liking. This will take care of housekeeping tasks like purging deleted VMs from the configuration.

### First Test ###

For a first test use the `vm-find.pl` tool under `tools/`. If the vSphere connection is set up correctly it will list all VMs with their UUIDs and a Perl data structure with all the information the LML knows about your VMs:
```
www-data@dev4003:/var/www/boot/lml$ tools/vm-find.pl
vm-find Version 1.0 2011-05-02
Copyright 2011 by Schlomo Schapiro, Immobilien Scout GmbH
Licensed under the GNU General Public License, see http://www.gnu.org/licenses/gpl.txt for full license

Connecting to VI

The following Custom Attribute Keys are defined (use the name as an argument to --tag):
ID  Name
 2: Contact User ID
 1: Expires

Searching for VMs
Found 24 VMs


 UUID                                  PATH

4213827b-dd40-8715-5bf2-85d4320a4c76  development/vm/ESB/devesb002
564dd99f-3819-ac28-b0b6-39d3b0083357  development/vm/Archive/RPM PoC/system
42132df0-b6c3-7594-b42c-7b417bf287c6  development/vm/Users/Schlomo Schapiro/devxen001
4213de19-c438-e789-49e7-b686d48d385e  development/vm/Playground/devgss001
...
$VM = {
        "4213de19-c438-e789-49e7-b686d48d385e" => { 
                                                    "CUSTOMFIELDS" => { 
                                                                        "Contact User ID" => "sschapiro",
                                                                        "Expires" => "31.12.2012"
                                                                      },
                                                    "EXTRAOPTIONS" => { 
                                                                        "bios.bootDeviceClasses" => "allow:net"
                                                                      },
                                                    "MAC" => { 
                                                               "00:50:56:93:00:18" => "arc.int"
                                                             },
                                                    "MO_REF" => bless( { 
                                                                         "type" => "VirtualMachine",
                                                                         "value" => "vm-47"
                                                                       }, 'ManagedObjectReference' ),
                                                    "NAME" => "devgss001",
                                                    "PATH" => "development/vm/Playground/devgss001",
                                                    "UUID" => "4213de19-c438-e789-49e7-b686d48d385e"
                                                  },
      };

```

Next run the `pxelinux.pl` script manually with a UUID as parameter (this simulates the network boot and is much faster). If all works well you should get a 3xx return code:
```
www-data@dev4003:/var/www/boot/lml$ ./pxelinux.pl 4213de19-c438-e789-49e7-b686d48d385e
Status: 302 VM is devgss001 and all is fine
Location: http://default
Content-Type: text/plain; charset=ISO-8859-1

```

### Putting it All Together ###

Now it is time to put all the pieces to work together and making sure that all components work together, please refer to the included sample config files for hints how to do this:
  * The DHCP server must set the pxelinux prefix (DHCP option 210) to point to the HTTP server and the location of LML, e.g. `http://<host>/boot`
  * The HTTP server must be set up to pass any calls to `pxelinux.cfg/<UUID>` to the pxelinux.pl script
  * There must be a default configuration in `pxelinux.cfg/default` as `pxelinux.pl` redirects the client there if all is fine

### Detailed Configuration ###

After getting LML to work you can try out is various features and options. Please refer to [Configuration](Configuration.md) for details.