Gentoo Overlay
==============

I, Corin Lawson, am a gentoo user; this is my overlay for personal use. If you
intend to use this overlay I recommend that you consider it
[unsafe](http://wiki.gentoo.org/wiki/Overlay#Using_unsafe_overlays).
In short, it works for me, YMMV.

Installation
------------

~~The following treatment comes from the
[gentoo wiki](http://wiki.gentoo.org/wiki/Overlay), please refer to that for all
the details.~~
*Superceeded by*
[New portage plug-in sync system](https://www.gentoo.org/support/news-items/2015-02-04-portage-sync-changes.html)

3. Add au-phiware overlay.

        # echo '*/*::au-phiware' >> /etc/portage/package.mask
        # echo 'you-decide/pkg-name::au-phiware' >> /etc/portage/package.unmask
        # echo '[au-phiware]
        location = /var/lib/overlays/au-phiware
        sync-type = git
        sync-uri = https://github.com/au-phiware/gentoo-overlay.git
        auto-sync = no' > /etc/portage/repos.conf/au-phiware.conf

4. Synchronise the remote repository.

        # emaint sync --repo au-phiware

    *Note: if you choose to set `auto-sync = yes` then the remote repository will
    be synchonised any and every time `emerge --sync` is run.*

5. Use overlay.

        # emerge -a you-decide/pkg-name

Note that for each package that you intend to merge, you will need to replace
*you-decide/pkg-name* with that package's name and have a separate entry in
`/etc/portage/package.unmask`.


Overlay Contents
----------------

### media-gfx/MatterControl

- Roughly follows [these instructions](http://wiki.mattercontrol.com/Building_MatterControl).

### app-i18n/fbterm

- Added solarized-dark and solarized-light USE flags,
  which sets the default colour palette to the
  [solarized](http://ethanschoonover.com/solarized) colour scheme
  (with dark or light barkground, respectively).

### sys-config/solarized

- Adds solarized colours to grub's kernel parameters.
- Defines solarized colours in global xresources
