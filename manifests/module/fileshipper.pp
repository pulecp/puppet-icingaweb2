# == Class: icingaweb2::module::fileshipper
#
# The fileshipper module extends the Director. It offers import sources to deal with CSV, JSON, YAML and XML files.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# [*install_method*]
#   Install methods are `git`, `package` and `none` is supported as installation method. Defaults to `git`
#
# [*package_name*]
#   Package name of the module. This setting is only valid in combination with the installation method `package`.
#   Defaults to `icingaweb2-module-fileshipper`
#
# [*base_directories*]
#   Hash of base directories. These directories can later be selected in the import source (Director).
#
# [*directories*]
#   Deploy plain Icinga 2 configuration files through the Director to your Icinga 2 master.
#
class icingaweb2::module::fileshipper(
  Enum['absent', 'present']      $ensure           = 'present',
  String                         $git_repository   = 'https://github.com/Icinga/icingaweb2-module-fileshipper.git',
  Optional[String]               $git_revision     = undef,
  Enum['git', 'none', 'package'] $install_method   = 'git',
  Optional[String]               $package_name     = 'icingaweb2-module-fileshipper',
  Hash                           $base_directories = {},
  Hash                           $directories      = {},
){

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/fileshipper"

  if $base_directories {
    $base_directories.each |$identifier, $directory| {
      icingaweb2::module::fileshipper::basedir{$identifier:
        basedir => $directory,
      }
    }
  }

  if $directories {
    $directories.each |$identifier, $settings| {
      icingaweb2::module::fileshipper::directory{$identifier:
        source     => $settings['source'],
        target     => $settings['target'],
        extensions => $settings['extensions'],
      }
    }
  }

  icingaweb2::module { 'fileshipper':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    install_method => $install_method,
    package_name   => $package_name,
  }
}
