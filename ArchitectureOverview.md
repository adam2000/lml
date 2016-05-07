# Big Picture #

Lab Manager Light contains or uses the following components
  * VMware vSphere: Virtualization Platform. ATM LML requires a vCenter Server (somehow the API seems a little different when talking to an ESXi server).
  * A dedicated network for VMs managed through LML.
  * ISC DHCP Server 3: Used to manage the IPs in the dedicated network and provide PXE boot infos.
  * DNS Server: Used to manage the DNS names for the dedicated network. Must be something that can be managed by the ISC DHCP Server through dynamic DNS updates. Tested with ISC Bind 9 so far.
  * [gPXE](http://etherboot.org): Used as part of [pxelinux](http://syslinux.zytor.com/wiki/index.php/PXELINUX) in the form of gpxelinux.0
  * TFTP Server: Provide pxelinux.0
  * HTTP Server: Interface between LML scripts and pxelinux boot environment
  * Many Perl Modules

The Overview of all LML components looks like this:
![http://lml.googlecode.com/hg/images/big-picture.png](http://lml.googlecode.com/hg/images/big-picture.png)

# Workflow #

In general the workflow with LML looks like this:
![http://www.websequencediagrams.com/cgi-bin/cdraw?lz=VXNlciAtPiBWTTogQ3JlYXRlIG9yXG4gQ29uZmlndXJlCgAWDFN0YXJ0ClZNIC0-IExNTDogUFhFIFJlcXVlc3RcbihESENQKQpMTUwASghQWEUgQm9vdFxuKHB4ZWxpbnV4KQAzDAphY3RpdmF0ZSBMTUwAMQh2U3BoZXJlOiBHZXQgVk0gRGF0YVxuKEFQSSkKABUHAHcJUmV0dXJuABYQAHsHAIEdBUNoZWNrXG4AQQcAUxFSZWMAgWIIIFZNXG4ob3B0aW9uYWxseSkKYWx0IEFsbCBpcyBmaW5lAIFODEJvb3QgTWVudQCBSBNVc2VyOiBTaG93IGIAgXgFbWVudQCCOw1DaG9vc2UgbmV0d29ya1xub3IgbG9jYWwAKwUKZWxzZSBTb21lIGVycm9ycyBkZXRlY3RlZACCTwxFcnJvciBJbmZvXG5hcyAAglcIAIEPCgpkZQCCUQ0AgQsRAD0FcwCDUw0AggMLXG5GaXgADhYAgR8GbmQK&s=modern-blue&.png](http://www.websequencediagrams.com/cgi-bin/cdraw?lz=VXNlciAtPiBWTTogQ3JlYXRlIG9yXG4gQ29uZmlndXJlCgAWDFN0YXJ0ClZNIC0-IExNTDogUFhFIFJlcXVlc3RcbihESENQKQpMTUwASghQWEUgQm9vdFxuKHB4ZWxpbnV4KQAzDAphY3RpdmF0ZSBMTUwAMQh2U3BoZXJlOiBHZXQgVk0gRGF0YVxuKEFQSSkKABUHAHcJUmV0dXJuABYQAHsHAIEdBUNoZWNrXG4AQQcAUxFSZWMAgWIIIFZNXG4ob3B0aW9uYWxseSkKYWx0IEFsbCBpcyBmaW5lAIFODEJvb3QgTWVudQCBSBNVc2VyOiBTaG93IGIAgXgFbWVudQCCOw1DaG9vc2UgbmV0d29ya1xub3IgbG9jYWwAKwUKZWxzZSBTb21lIGVycm9ycyBkZXRlY3RlZACCTwxFcnJvciBJbmZvXG5hcyAAglcIAIEPCgpkZQCCUQ0AgQsRAD0FcwCDUw0AggMLXG5GaXgADhYAgR8GbmQK&s=modern-blue&.png) [Edit](http://www.websequencediagrams.com/?lz=VXNlciAtPiBWTTogQ3JlYXRlIG9yXG4gQ29uZmlndXJlCgAWDFN0YXJ0ClZNIC0-IExNTDogUFhFIFJlcXVlc3RcbihESENQKQpMTUwASghQWEUgQm9vdFxuKHB4ZWxpbnV4KQAzDAphY3RpdmF0ZSBMTUwAMQh2U3BoZXJlOiBHZXQgVk0gRGF0YVxuKEFQSSkKABUHAHcJUmV0dXJuABYQAHsHAIEdBUNoZWNrXG4AQQcAUxFSZWMAgWIIIFZNXG4ob3B0aW9uYWxseSkKYWx0IEFsbCBpcyBmaW5lAIFODEJvb3QgTWVudQCBSBNVc2VyOiBTaG93IGIAgXgFbWVudQCCOw1DaG9vc2UgbmV0d29ya1xub3IgbG9jYWwAKwUKZWxzZSBTb21lIGVycm9ycyBkZXRlY3RlZACCTwxFcnJvciBJbmZvXG5hcyAAglcIAIEPCgpkZQCCUQ0AgQsRAD0FcwCDUw0AggMLXG5GaXgADhYAgR8GbmQK&s=modern-blue)