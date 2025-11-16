#!/usr/bin/env bash

exec borg create --progress --stats "$XDG_RUNTIME_DIR/gvfs/smb-share:server=fileserver,share=files,user=mixa/misha-backup/borg::Dropbox$(date +%Y-%m-%dT%H-%M-%S)" "$HOME/Dropbox"
