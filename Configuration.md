# Semantics #

LML uses a simple INI file '/etc/lml.conf' for configuration. The Perl [Config::IniFiles](http://search.cpan.org/~shlomif/Config-IniFiles-2.66/lib/Config/IniFiles.pm) modules used here supports some extensions which are also used partially by LML:
  * comments starting with '#'
  * multi-line values like this
```
[section]
key=<<EOF
value line 1
value line 2
...
EOF
```
  * sections and keys are not case sensitive. Nevertheless it is recommended to write everything lower case.

In general all non-mandatory keys can be removed or commented out with '#' to disable a feature or setting.

# Details #

ATM please refer to the comments in '[lml.conf](http://code.google.com/p/lml/source/browse/etc/lml.conf)'