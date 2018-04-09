# unpack phpwiki from zip file
class phpwiki::install (
  $version         = $phpwiki::version,
  $source_url      = $phpwiki::source_url,
  $install_root    = $phpwiki::install_root,
  $owner           = $phpwiki::owner,
  $writeable_owner = $phpwiki::writeable_owner,
  $group           = $phpwiki::group,
) {

  include 'archive'
  include 'stdlib'

  if $source_url {
    $source = $source_url
  } else {
    $source = "https://sourceforge.net/projects/phpwiki/files/phpwiki-${version}.zip"
  }

  file { $install_root:
    ensure => 'directory',
    mode   => '0750',
    owner  => $owner,
    group  => $group,
  }

  file { "${install_root}/phpwiki-${version}":
    ensure  => 'directory',
    mode    => '0750',
    owner   => $owner,
    group   => $group,
    require => Archive['/tmp/phpwiki.zip'],
  }

  file { "${install_root}/phpwiki-${version}/uploads":
    ensure  => 'directory',
    mode    => '0770',
    owner   => $writeable_owner,
    group   => $group,
    recurse => true,
    require => Archive['/tmp/phpwiki.zip'],
  }

  archive { '/tmp/phpwiki.zip':
    source       => $source,
    extract      => true,
    creates      => "${install_root}/phpwiki-${version}/index.php",
    user         => $owner,
    group        => $group,
    extract_path => $install_root,
    require      => File[$install_root],
  }

  if ! defined(Package['php-mbstring']) {
    package { 'php-mbstring':
        ensure => installed,
    }
  }

}