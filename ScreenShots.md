Lab Manager Light works at the early boot stage trough PXE menu. Therefore the interaction with the user also happens through the console of a VM.


Typical error report telling the user what to fix in the VM configuration. The user can only reboot the VM and LML won't allow the VM to boot into the OS without fixing the issues:
![http://lml.googlecode.com/hg/images/lml-error-report.png](http://lml.googlecode.com/hg/images/lml-error-report.png)

After fixing the issues the user passes the LML checks ang goes to the default PXE boot menu:
![http://lml.googlecode.com/hg/images/lml-boot-ok.png](http://lml.googlecode.com/hg/images/lml-boot-ok.png)

In this case, the VM custom fields hat to be filled in correctly to reflect the User ID and Expiry Date of the user and the VM had to be renamed to fulfill the company naming policy, for example the Custom Fields look like this:
![http://lml.googlecode.com/hg/images/lml-vsphere-client-custom-fields.png](http://lml.googlecode.com/hg/images/lml-vsphere-client-custom-fields.png)

Images are courtesy of [ImmobilienScout24](http://www.immobilienscout24.de) ![http://lml.googlecode.com/hg/images/is24-logo.png](http://lml.googlecode.com/hg/images/is24-logo.png)