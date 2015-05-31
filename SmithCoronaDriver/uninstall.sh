#!/bin/sh

# uninstall.sh
# unistall Lisanet PDFwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.

sudo rm /Library/Printers/Lisanet/PDFwriter/*
sudo rm /Library/Printers/Lisanet/PDFwriter/.DS_S*
sudo rm /Library/Printers/Lisanet/.DS_S*
sudo rm /usr/libexec/cups/backend/pdfwriter
sudo rm /usr/share/cups/model/PDFwriter.ppd


sudo rmdir /Library/Printers/Lisanet/PDFwriter
sudo rmdir /Library/Printers/Lisanet

sudo pkgutil --forget de.lisanet.PDFwriter.pkg 