#!/bin/bash

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.


# make symlinks
ln -s /Library/Printers/Lisanet/PDFwriter/pdfwriter /usr/libexec/cups/backend/pdfwriter
ln -s /Library/Printers/Lisanet/PDFwriter/PDFwriter.ppd /usr/share/cups/model/PDFwriter.ppd

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist