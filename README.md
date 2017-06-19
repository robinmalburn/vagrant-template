# Vagrant Template

This is a simple Vagrant template to take away some of the boilerplate set up when working on new projects.  It's largely targeted at my own needs, but hopefully some of the other elements, particularly with regards to Provisioning might be helpful to others, too.

## Placeholder Replacement

In the `Vagrantfile` itself, for a minimal set up, the only values that really need updating are:

 - `config.vm.box`: Currently set to *ubuntu/xenial64* as a sane default, but update to your Vagrant box of choice.
 - `vb.name`: Currently set to *placeholder-name* as a sane default, feel free to rename the VM to whatever you like, or remove this entirely if you don't care to name your VMs.

## Provisions

Provisioning a complicated project in Vagrant can often start to get messy and inflexible - this template aims to resolve that by offering a basic, pseudo-framework for dealing with provisioning.

Provisions are ran through `vagrant/provisions/runner.sh`, which sets some useful, if occasionally opinionated (and as a result optional) settings and constraints to run provisions under.  Beyond that, provisions are also broken down into four different types of provisions that run with different privilege levels and at different times in the Vagrant life-cycle, as documented below.

Provisions **MUST** be shell scripts ending in `.sh` and **MUST** be placed in the relevant subfolder of `vagrant/provisions` for the desired privilege/life-cycle provision.  The available subfolders are:

- `vagrant/provisions/privileged-always`
- `vagrant/provisions/privileged-once`
- `vagrant/provisions/unprivileged-always`
- `vagrant/provisions/unprivileged-once`

### Provision Types

Their are four types of provision available split between two types of privilege and two types of life-cycle level, which are defined below.

#### Privileges 

 - Privileged
   - These provisions are ran as a privileged user, e.g. Root or Sudo.
 - Unprivileged
   - These provisions are ran as the standard user (normally vagrant, though this is box dependent) and will generally not have administrator level
     permissions.

#### Life-Cycle

 - Always
   - These provisions are ran every time the Vagrant instance is booted through
   `vagrant up`.
 - Once
   - These provisions are ran only in response to provision command, e.g any of the follow:
     - `vagrant up` - the very first time the box is booted and **MUST** be provisioned.
     - `vagrant provision`
     - `vagrant reload --provision`

### The opinionated bits...

Scripting in Bash is an adventure in much the same way putting your hand into a bag of broken glass is an adventure, to mitigate that, the provision runner has a few defaults sets to try and make scripting provisions a little less of an adventure.  You can of course comment them out if they're not to your taste, but that's between you and the bag of broken glass at that point. 

 - `set -o nounset` - This causes bash to complain if you reference an undeclared variable and to raise an error.
 - `set -o errexit` - This causes bash to exit on error, working quite nicely with the setting above.
 - `set - o xtrace` - This one is actually commented out but is left to help with debugging awkward provisions - uncommenting this setting will cause bash
   to emit debug info with each action that can help in tracking down the cause of failures or unexpected behaviour.
 - `export DEBIAN_FRONTEND=noninteractive` - I work almost exclusive in Debian-based environments, so this setting just make sense for me to have as
   it informs the system not to expect an interactive prompt.  If you're not using a Debian based box, this is likely not relevant for you.
