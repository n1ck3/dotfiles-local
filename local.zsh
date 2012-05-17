# zshrc local user configuration by Lowe Thiderman (daethorian@ninjaloot.se)
# Released under the WTFPL (http://sam.zoy.org/wtfpl/).
#
# <github link>

# This is a file containing user specific configuration for zsh. While the
# original intent is for .zshrc to contain all this, it becomes troublesome
# whenever you want to share your zshrc and those you share it with make
# changes.

# The best way to use this file is to copy it to ~/config/zsh/$USER.conf and
# mofify it to your needs. Whenever the zsh is updated (from git ;)), your
# changes will be intact and you can diff properly without conflicts. Sweet.
# $USER.conf files will be sourced from the main zshrc in favor of this file.

# Within this file there are several boolean togglers. If not stated otherwise,
# they need to be set _and_ have a value of true. This way both commenting them
# out and setting them to false will have immediate effect.

# User settings {{{
    # User information {{{
        # Your main alias. If $USER is the same as $ALIAS, the prompt will save
        # space and only show the hostname instead of both the username and the
        # hostname.
        export ALIAS='nicke'
        # Set what kind of BOX we are on
        BOX=$(uname)

        # Your main remote site. Currently not widely used. Backup and connection
        # testing functions are planned.
        export REMOTE='b19.dyndns.org'

        # Your full name. Used with git configurations.
        export FULLNAME="Niclas Helbro"

        # Your email adress. Used with git configurations.
        export EMAIL="${ALIAS}@$REMOTE"
    # }}}
    # User prompt settings {{{
        # Your prompt mode. Currently four modes are supported:
        # #0: A simple % (user) or # (root). No more, no less. Used for minimalism.
        # #1: $USER@$HOST $PWD. Identical to Gentoos basic bash prompt. Used for consoles.
        # Will not expand back to only $HOST if $USER and $ALIAS match.
        #
        # #2: The default prompt. Uses double rows and is pretty advanced.
        # Always shows current machine, current PWD and a clock.
        # It also has several situational modules:
        #     # Exitstatus. Shown whenever exitstatus is non-zero.
        #     # Jobs. Shown whenever you have backgrounded jobs.
        #     # Mail. Shown whenever there are files in any maildir in $MAIL.
        #     # Battery. Shown if laptop and if battery is toggled.
        #
        # Mail and battery requires simple setting up and are ignored otherwise.
        #
        # #3: The CVS prompt. Identical to #2, but inserts CVS info in a middle row.
        # It is automatically toggled whenever you enter a directory that contains
        # CVS files, and automatically reverted whenever you leave.
        #
        # You can toggle between the prompts using the simple p() shell function
        # using numerical arguments. If you give a boolean argument (true/false),
        # the prompt will set $PKEEP. If $PKEEP is true, the prompt will not
        # try to automatically switch to the CVS prompt.
        export PMODE=4
        export PKEEP=true

        # Force the console to use prompt #1
        export FORCE_CONSOLE=true

        # Force mobile connections (any $TERM that is 'xterm') to use prompt #0.
        export FORCE_MOBILE=false

        # Make root timeout after 180 seconds for security reasons.
        # Unset (and/or comment out here) to disable.
        export ROOT_TIMEOUT=180
    # }}}
    # User configurations {{{
        export CONFIG="$HOME/config"
    # }}}
    # User editor {{{
        # Your editor. If an alias exists for it, it will be unaliased to avoid
        # confusion and breakage. (if one exists and you run which on it, which will
        # not return an absolute path to the application)
        local _EDITOR='vim'

        if alias $_EDITOR &> /dev/null ; then
            unalias $_EDITOR
        fi

        if which $_EDITOR &> /dev/null ; then
            export EDITOR=$(which $_EDITOR)
        else
            export EDITOR=$(which vi)
        fi

        # Your visual editor. Nuff said.
        export VISUAL=$EDITOR
        alias e=$EDITOR
    # }}}
    # User colorscheme {{{
        export ZCOLOR="default"
    # }}}
    # User directories and logs {{{
        # Your mail directory. If set and exists, the prompt will look for new mail
        # in maildirs within it. The principle is simple and very primitive, so any
        # file within a directory named new/ inside $MAIL will trigger the mail
        # count.
        # Note that unlike most directories bound to the zsh conf, $MAIL will not be
        # created automatically.
        export MAIL="$HOME/mail"

        # Your log directory. zsh will place it's history there instead of
        # cluttering the $HOME.
        # XDG misses a log specification :(
        export LOGS="$HOME/.local/logs"

        HISTFILE="$LOGS/zsh.history.log"
        HISTSIZE=100000
        SAVEHIST=100000
    # }}}
    # # User laptop settings {{{
    #     # Set if laptop. If false, no battery settings will take place.
    #     export LAPTOP=true

    #     # Battery settings.
    #     # If the file $BAT exists, the prompt triggers the battery module.
    #     # When triggered, it writes a simple cache to $BATC and uses this for $BATS
    #     # seconds. $BATT is the timestamp of when the cache was last reset.
    #     # The cache is mainly to not access battery files every time a prompt is
    #     # read.
    #     if [[ -n "$LAPTOP" ]] && $LAPTOP ; then
    #         export BAT='/tmp/battery'
    #         export BATC='/tmp/battery_cache' # Battery cache
    #         export BATT=0 # Battery timeout
    #         export BATS=30 # Battery shift
    #     fi

    #     # Your home network name.
    #     export HOMENET="ninjanet"
    # # }}}
    # User multiplexer {{{
        # Your terminal multiplexer. If installed and you are not currently in it
        # (whether you are or not is decided if $TERM is equal to $MULTITERM) the
        # PWD in the prompt will be red. Unset $MULTI to disable.
        export MULTI='tmux'
        export MULTITERM='screen-256color'
    # }}}
    # User chpwd and path {{{
        # Your todo list. The defaults are specified for devtodo
        # (http://swapoff.org/DevTodo). If $TODO is installed and $TODOFILE is in
        # the current directory, $TODO is run upon chpwd().
        # export TODO='todo'
        # export TODOFILE='.todo'

        # When I used lscmd() (included in main zshrc) and found out that 25% of all
        # the commands I ever used in zsh was ls, I figured that it could be more
        # effective and put ls into chpwd.
        # It takes some getting used to, but it is really worth it!
        # export CHPWD=true

        # Your choice of chpwd() command.
        _chpwd() {
            ls
        }

        # Your home bin. In the rc there are functions included that handles
        # installation and uninstallation of custom executables. If this is desired,
        # $HOMEBIN must of course be included in your path.
        export HOMEBIN="$HOME/.local/bin"

        # Your path. Remember to separate additional directories with a colon.
        local _PATH="$HOME/bin:$HOMEBIN"
        _PATH+=:/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin

        # If $_PATH is not in $PATH, add it, but only once.
        if ! [[ $PATH =~ "$_PATH" ]] ; then
            export PATH=$_PATH:$PATH
        fi

        # Your man path. Remember to separate additional directories with a colon.
        local _MANPATH=/opt/local/share/man

        # If $_MANPATH is not in $MANPATH, add it, but only once.
        if ! [[ $MANPATH =~ "$_MANPATH" ]] ; then
            export MANPATH=$_MANPATH:$MANPATH
        fi
    # }}}
    # User coreutils options {{{
        # It is not uncommon to always supply some arguments to common commands. ls
        # and grep needs colors, right?
        LSOPTS=''
        if [ $BOX = "Darwin" ] ; then
            LSOPTS='--color=auto'
        elif [ $BOX = "Linux" ] ; then
            LSOPTS='--color=auto --group-directories-first'
        fi

        export LSOPTS=$LSOPTS
        export GREPOPTS='--color=auto'
    # }}}
# }}}
# Modules {{{
    # zsh module directory
    export ZMODDIR="$HOME/config/zsh/modules"

    # Set the loaded module array
    ZMODULES=()
    export ZMODULES

    # Core modules are recommended and should most probably always be loaded.
    for i in $ZMODDIR/core/* ; do
        _modload $i
    done

    # Chpwd. If you want commands executed on cd, this is the way to go.
    # _modload "chpwd"

    # Colorscheme printers. Only useful if you customize alot.
    _modload "colors"

    # Configuration specific aliases
    _modload "conf"

    # Failsafe aliases that catches common misspelled commands and runs the
    # original ones. Also, it is incredibly angry.
    _modload "failsafe"

    # Management of local home path
    _modload "install"

    # LOLCODE!! Mostly useless but kinda lolz.
    # _modload "lolcode"

    # Mounting aliases.
    # _modload "mount"

    # Shell syntax highlighting. Cannot be sourced by _modload
    source $ZMODDIR/syntax.zsh

    # Application specific modules; loaded if they are installed
    for m in $ZMODDIR/apps/* ; do
        app=${${m##*/}%\.*}  # Strip down to the actual executable name
        _zdebug "Testing for $app"
        if _has $app ; then
            _modload "apps/$app"
        fi
    done
    unset m
# }}}

# User zsh specifics {{{
    # zsh specific directory that the core shell might use for dumping etc. Only
    # used when set.
    export ZDUMPDIR="$XDG_DATA_HOME/zsh"

    # The completion system uses a cache file to speed up completion. To avoid
    # cluttering the $HOME, it is put inside $ZDUMPDIR
    export COMPDUMP="$ZDUMPDIR/compdump"

    # Use the debugger?
    #export DEBUG=false

    # The globbing!
    setopt extendedglob
    umask 022

    # While vim is superior, shells in vi mode are unfortunately not.
    bindkey -e
# }}}
# User custom whatever {{{

    # Put whatever else you want here that is specific to your setup.
    # export PYLINTRC="$HOME/.config/pylint/pylintrc"
    #export DJANGO_SETTINGS_MODULE="settings"

    # alias wpg="touch /tmp/gemma && wp"
    # alias wpn="rm /tmp/gemma &> /dev/null && wp"

    lscf=$HOME/config/zsh/LS_COLORS/LS_COLORS
    if [[ -f $lscf ]] ; then
        eval $(dircolors -b $lscf)
    fi

    # PMODE Helper
    alias pt='p true'
    alias pf='p false'
    alias p0='p 0'
    alias p1='p 1'
    alias p2='p 2'
    alias p3='p 3'
    alias p4='p 4'
    alias p5='p 5'

    # Edit configuration file
    alias zn='vim ~/cfg/nicke.zsh'
    alias vn='vim ~/cfg/nicke.vim'

    # Complete parent dir on $ ..<TAB>
    zstyle ':completion:*' special-dirs true

    # Development aliases
    if [ $BOX = "Darwin" ] ; then
        alias mat='sshfs at:/srv/live/ $HOME/dev/django/at -oauto_cache,reconnect,volname=at'
        alias umat='umount at'
        alias umfat='sudo diskutil unmount force /Users/nicke/dev/django/at'

        alias mnt='sshfs nt:/srv/live/ $HOME/dev/django/nt -oauto_cache,reconnect,volname=nt'
        alias umnt='umount nt'
        alias umfnt='sudo diskutil unmount force /Users/nicke/dev/django/nt'

        alias mvs='sshfs vs:/srv/live/ $HOME/dev/django/vs -oauto_cache,reconnect,volname=vs'
        alias umvs='umount vs'
        alias umfvs='sudo diskutil unmount force /Users/nicke/dev/django/vs'

    elif [ $BOX = "Linux" ] ; then
        alias cdm='cd /srv/live'

        alias nr='service nginx restart'
        alias tna='tail -f /var/log/nginx/access.log'
        alias tne='tail -f /var/log/nginx/error.log'

        alias ar='service apache2 restart'
        alias tae='tail -f /var/log/apache2/error.log'
        alias taa='tail -f /var/log/apache2/access.log'

        alias dmmm="django-admin.py makemessages -a"
        alias dmcm="django-admin.py compilemessages"

    fi

    # Override Lowes ridiculous dr() bs.
    dr () {
        if [[ ! -f "manage.py" ]]
        then
            _zerror "No django manager found. Exiting"
            return 1
        fi

        echo -e "\nRemoving .pyc files"
        rmext pyc &> /dev/null
        echo -e "Removed .pyc files"
        python2 manage.py runserver 0.0.0.0:8000 --traceback
    }

#}}}

# vim: ft=zsh fmr={{{,}}}
