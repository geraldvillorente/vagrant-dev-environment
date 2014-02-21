Vagrant Drupal Development
==========================

Vagrant Development Environment (VDE)is fully configured and ready to use
development environment built on Linux (Ubuntu 12) with Vagrant, VirbualBox and
Chef Solo provisioner. VDE is virtualized environment, so your base system will
not be changed and remain clean after installation. You can create and delete as
much environments as you wish without any consequences.


Setup is very simple, fast and can be performed on Windows, Linux or Mac
platforms. It's simple to clone ready environment to your Laptop or home
computer and then keep it synchronized.

If you don't familiar with Vagrant, please read about it. Documentation is very
simple to read and understand. http://docs.vagrantup.com/v2/

To start VDE you don't need to write your Vagrantfile. All configurations can be
done inside simple JSON configuration file.


Out of the box features
=======================

  * Configured Linux, Apache, MySQL and PHP stack
  * Drush with site aliases
  * PhpMyAdmin
  * Xdebug
  * Supports Drupal

TODO:

  * Webgrind
  * Xhprof
  * Mailing system
  * Other development tools and useful software


Getting Started
===============

VDE uses Chef Solo provisioner. It means that your environment is built from
the source code. All you need is to get base system, the latest code and build
your environment.

  1. Install VirtualBox
     https://www.virtualbox.org/wiki/Downloads

  1. Install Vagrant
     http://docs.vagrantup.com/v2/installation/index.html

  1. Install vagrant host updater plugin. Please note on this one that "plugin" is not available in some lower version       of Vagrant. The solution so far is to upgrade to higher versions.
     `$ vagrant plugin install vagrant-hostsupdater`

  1. Prepare VDE source code
     Download and unpack VDE source code and place it inside your local development folder.
     `git clone CLONE_URL_OF_THIS_REPO`

  1. Adjust configuration | Copy `config.example.json` to `config.json`
     You can edit `config.json` file to adjust your settings. If you use VDE first
     time it's recommended to leave the original config as is.

  1. Build your environment (Note : You might want to add your project before doing this step)
     To build your environment execute next command inside your VDE copy:
     `$ vagrant up --provision`

     Vagrant will start to build your environment. You'll see green status
     messages while Chef is configuring the system.

     If during `vagrant up` you encountered the below message, that means you don't have NFS. Also, take note that if        you're on Windows, NFS isn't supported.

     ```
     Bringing machine 'default' up with 'virtualbox' provider...
     There are errors in the configuration of this machine. Please fix
     the following errors and try again:

     vm:
     * It appears your machine doesn't support NFS, or there is not an
     adapter to enable NFS on this machine for Vagrant. Please verify
     that 'nfsd' is installed on your machine, and try again. If you're
     on Windows, NFS isn't supported. If the problem persists, please
     contact Vagrant support.
     ```

     In Debian/Ubuntu, you can install the required package using this command.

     `$ sudo apt-get install nfs-common nfs-kernel-server`

  1. Visit `192.168.44.45` address OR the hostname specified in the config.json
     If you didn't change the default IP address in `config.json` file you'll see
     VDE's main page. Main page has links to configured sites, development tools
     and list of frequently asked questions. Follow instruction on how to quickly install Drupal


It's now time to add your default project inside the `www` folder.

Basic Usage
===========

Inside your VDE copy's directory you can find `data` directory. It's
synchronized with virtual machine. You should place your application's files
inside sub folders with the name of your project. You can edit your application's
files on the host machine using your favorite editor or connect to virtual
machine by SSH. VDE will never delete data from data directory, but you should
backup it.

Vagrant's basic commands (should be executed inside VDE directory):

  * `$ vagrant ssh`
    _SSH into virtual machine._

  * `$ vagrant up`
    _Start virtual machine._

  * `$ vagrant halt`
    _Halt virtual machine._

  * `$ vagrant destroy`
    _Destroy you virtual machine. Source code and content of data directory will
    remain unchangeable. VirtualBox machine instance will be destroyed only. You
    can build your machine again with `vagrant up` command. The command is
    useful if you want to save disk space._

  * `$ vagrant provision`
    _Reconfigure virtual machine after source code change._

  * `$ vagrant reload`
    _Reload virtual machine. Useful when you need to change network or
    synced folder settings._

Official Vagrant site has beautiful documentation.
http://docs.vagrantup.com/v2/

Drush Integration
=================

If your `Host` machine has Drush already you can use it to manage your VDE environment. All you need to do is create a file called `VDE.aliases.drushrc.php` in `~/.drush` in your host machine. The file should contain the below script.

```
<?php
$aliases['VDE'] = array(
  'parent' => '@parent',
  'site' => 'VDE',
  'env' => 'local',
  'uri' => 'VDE/drupal7',
  'root' => '/var/www/drupal7/',
  'remote-host' => '192.168.44.44',
  'remote-user' => 'vagrant',
);
```

To be able to execute Drush commands against VDE, while on your host machine:

`$ drush @VDE [DRUSH_COMMAND]`

Examples:

`$ drush @VDE cc all`<br>
`$ drush @VDE en views -y`<br>
`$ drush @VDE vset preprocess_css 1 -y`<br>
`$ drush @VDE status`<br>

Also make sure that you uploaded the host public key on Vagrant.


Customizations
==============

You should understand that every time you start virtual machine Vagrant will
fire Chef provisioner. If you want to customize your VDE copy you should do it
right way.

Templates override

If you want to change some configuration files, for example, php.ini you should
override default VDE's template. All templates a located in
`cookbooks/VDE/VDE/templates/default`

All you need is to copy template file into `cookbooks/core/VDE/templates/ubuntu`
directory and edit it.

Writing custom role

If you want to make serious modifications you should write your custom role and
add it in `config.json` file. Please, see `VDE_example.json` file inside roles
directory.

config.json description
=======================

`config.json` is the main configuration file. Data from `config.json` is used to
configure virtual machine. After editing file make sure that your JSON syntax is
valid. http://jsonlint.com/ can help to check it.

  * `hostname (string, required)`
    _URL of the machine automatically added to the /etc/hosts if you have vagrant
    host updater plugin (vagrant plugin install vagrant-hostsupdater)_

  * `ip (string, required)`
    _Static IP address of virtual machine. It is up to the users to make sure
    that the static IP doesn't collide with any other machines on the same
    network. While you can choose any IP you'd like, you should use an IP from
    the reserved private address space._

  * `memory (string, required)`
    _RAM available to virtual machine. Minimum value is 1024._

  * `synced_folder (object of strings, required)`
    _Synced folder configuration._

      * `host_path (string, required)`
        _A path to a directory on the host machine. If the path is relative, it
        is relative to VDE root._

      * `guest_path (string, required)`
        _Must be an absolute path of where to share the folder within the guest
        machine._

      * `use_nfs (boolean, required)`
        _In some cases the default shared folder implementations (such as
        VirtualBox shared folders) have high performance penalties. If you're
        seeing less than ideal performance with synced folders, NFS can offer a
        solution. http://docs.vagrantup.com/v2/synced-folders/nfs._

  * `php (object of strings, required)`
    _PHP configuration._

      * `version (string or false, required)`
        _Desired PHP version. Please, see http://www.php.net/releases for proper
        version numbers. If you would like to use standard Ubuntu package you
        should set number to "false". Example: "version": false._

  * `mysql (object of strings, required)_`
    _MySQL configuration._

      * `server_root_password (string, required)`
        _MySQL server root password._

  * `sites (object ob objects, required)`
    _List of sites (similar to virtual hosts) to configure. At least one site is
    required._

      * `Key (string, required)`
        _Machine name of a site. Name should fit expression '[^a-z0-9_]+'. Will
        be used for creating subdirectory for site, Drush alias name, database
        name, etc._

          * `account_name (string, required)`
            _Drupal administrator user name._

          * `account_pass (string, required)`
            _Drupal administrator password._

          * `account_mail (string, required)`
            _Drupal administrator email._

          * `site_name (string, required)`
            _rupal site name._

          * `site_mail (string, required)`
            _Drupal site email._

  * `xdebug (object of strings, optional)`
    _Xdebug configuration._

    * `remote_host (string, required)`
      _Selects the host where the debug client is running._

  * `git (object of strings, optional)`
    _Git configuration._

  * `custom_roles (array, required)`
    _List of custom roles. Key is required, but can be empty array ([])._
