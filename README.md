
Install PhpWiki (https://sourceforge.net/projects/phpwiki/)

Only tested with versions 1.5.0 through 1.5.5.

Does not manage any webserver configuration.

Does not install or manage database server (e.g. mysql)


!! Parameters

`version` - PhpWiki version to install

`source_url` - URL for zip file download. Defaults to
https://sourceforge.net/projects/phpwiki/files/phpwiki-${version}.zip

`install_root` - full path where the PhpWiki zip fill will be unpacked.
The zip file is unpacked to a `phpwiki-${version}` subdirectory of
`install_root`. For example, given `install_root = /var/www/wiki` and
`version = 1.5.5` will result in the directory structure
`/var/www/wiki/phpwiki-1.5.5`

`owner` - owner for most of the files. It is recommended that it not be
the owner of the httpd process to reduce the chances of a remote exploit
changes files. The default is `root`.

`writeable_owner` - the owner of writeable directories and files, e.g.
the `uploads` directory. This should be the same as the httpd owner.
The default is `apache`.

group - the group for the installed files. The files are installed with
group read permissions so the httpd process can read but not write
permissions to reduce the chances of a remote exploit changing files. 
The default is `apache`,


See `templates/config.ini.erb` for information on the parameters used there.

If you use a file or dba backend be sure to set `database_directory`.
You are responsible for managing that directory with correct permissions
for the Wiki to write to it.

!! Patches

`phpwiki::patch` fixes or works around some know bugs.

- `File_line['patch-upgrade']`

Do not check for mysql LOCK TABLE privilege because it always fails.
https://sourceforge.net/p/phpwiki/mailman/phpwiki-talk/thread/443E952A.4000804@x-ray.at/

- `ExternalReferrer.php` 

search keyword highlighting is causing PHP runtime exceptions in
phpwiki-1.5.0 through 1.5.5 (at least) that are not worth trying to fix.
Disabling ENABLE_SEARCHHIGHLIGHT in config.ini causes OOM erros. So
disbable by emptying array.


- `UpLoad.php` - 1.5.3 through 1.5.5

Fixes upload path name construction by swapping ~ lines 135 and 136, to be

                $file_dir .= "/";
                $file_dir .= $username;
