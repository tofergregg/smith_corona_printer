#!/bin/bash

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.


# make symlinks
ln -s /Library/Printers/Gregg_Wasynczuk_Seabury/SmithCorona/smithcorona /usr/libexec/cups/backend/smithcorona
ln -s /Library/Printers/Gregg_Wasynczuk_Seabury/SmithCorona/SmithCorona.ppd /usr/share/cups/model/SmithCorona.ppd

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist