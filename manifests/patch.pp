# phpwiki is some buggy shit

class phpwiki::patch {

  $version      = $phpwiki::version
  $install_root = $phpwiki::install_root
  $owner        = $phpwiki::owner
  $group        = $phpwiki::group

  if $version == '1.5.3' or
    $version == '1.5.4' or
    $version == '1.5.5' {
    file { "${install_root}/phpwiki-${version}/lib/plugin/UpLoad.php":
      source  => 'puppet:///modules/phpwiki/patches/UpLoad.php',
      mode    => '0640',
      owner   => $owner,
      group   => $group,
      require => Archive['/tmp/phpwiki.zip'],
    }
  }

  # version == 1.5.0 or (version > 1.5.0 and < 1.5.6)
  if versioncmp( $version, '1.5.0') == 0 or
    (versioncmp( $version, '1.5.0') == 1 and
    versioncmp( $version, '1.5.6') == -1) {

    # disable check for mysql table lock because it always fails.
    # https://sourceforge.net/p/phpwiki/mailman/message/12413366/
    file_line { 'patch-upgrade':
      path    => "${install_root}/phpwiki-${version}/lib/upgrade.php",
      line    => '            return; # skipping because it always fails. Patched by Puppet phpwiki::install',
      after   => 'Check for mysql LOCK TABLE privilege',
      require => Archive['/tmp/phpwiki.zip'],
    }

    file { "${install_root}/phpwiki-${version}/lib/ExternalReferrer.php":
      source  => 'puppet:///modules/phpwiki/patches/ExternalReferrer.php',
      mode    => '0640',
      owner   => $owner,
      group   => $group,
      require => Archive['/tmp/phpwiki.zip'],
    }

  }

}