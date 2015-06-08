Gentoo Overlay
==============

I, Corin Lawson, am a gentoo user; this is my overlay for personal use. If you
intend to use this overlay I recommend that you consider it
[unsafe](http://wiki.gentoo.org/wiki/Overlay#Using_unsafe_overlays).

Installation
------------

The following treatment comes from the
[gentoo wiki](http://wiki.gentoo.org/wiki/Overlay), please refer to that for all
the details.

1. Get layman and git.

        # emerge --sync
        # emerge -av app-portage/layman dev-vcs/git

2. Use layman.

        # echo 'source /var/lib/layman/make.conf' >> /etc/portage/make.conf

3. Add au-phiware overlay.

        # echo '*/*::au-phiware' >> /etc/portage/package.mask
        # echo 'you-decide/pkg-name::au-phiware' >> /etc/portage/package.unmask
        # layman -o https://raw.githubusercontent.com/au-phiware/gentoo-overlay/master/overlay.xml -f -a au-phiware

  To permanently add the overlay open `/etc/layman/layman.cfg` with your
  favourite editor, find the `overlays:` section and append it to the list,
  like so:

      overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                  https://raw.githubusercontent.com/au-phiware/gentoo-overlay/master/overlay.xml

4. Synchronise the remote repository (this should be automatic in the above
   command).

        # layman -s au-phiware

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

