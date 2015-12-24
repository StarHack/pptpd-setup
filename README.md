pptpd-setup
===================

Tiny helper script automatically installing pptpd on a fresh debian box. Got tired of configuring each vm individually, as such I wrote this script.

**Make sure to edit login credentials.**

Simply clone this repository by issuing:
`git clone https://github.com/StarHack/pptpd-setup`

Change into the cloned directory:
`cd pptpd-setup/`

And **install** pptpd using:
`./pptpSetup.sh install`

In order to **remove** it again, you may simply use:
`./pptpSetup.sh remove`

After successful installation you may establish a **PPTP VPN Connection** to your server and login using the **username** and **password** you provided. By default, **yandex.ru dns server** is being used, but then again, you may use a dns server of your choice by editing the script accordingly.