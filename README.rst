==================
README for build_delta
==================

This is a small script for preparing xdelta upgrade of your
distribution package. The script produces tar.gz archive
with a patcher script to doing an incremental upgrade from
a client's version of DIR to the next version of the DIR with
the binary and text files.

Installing
==========

Install the newest version from github::

   git clone https://github.com/wws22/build_delta.git

Using
========

You should have two directories with your distribution packages
and xdelta package installed on your system <http://xdelta.org/>

.. code-block:: bash

    $sudo apt-get install xdelta
    #... Using ...
    $build_delta.sh <ver1dir> <ver2dir> <target_name>

Testing
========

You could use test_dirs.tar.gz file for some testing. This file
provides the array of test files in two directories v1 and v2.

.. code-block:: txt

    v1:
    drwxr-xr-x 2 user users 4096 Nov 16 14:45 .olddir
    drwxr-xr-x 2 user users 4096 Nov 16 13:57 subdir
    -rw-r--r-- 1 user users  221 Nov 16 13:00 .chang ed.zip
    -rw-r--r-- 1 user users  202 Nov 16 13:07 delbin.zip
    -rwxr-xr-x 1 user users   52 Nov 16 13:02 per sist.sh
    -rw-r--r-- 1 user users   31 Nov 17 11:48 persist.txt
    -rw-r--r-- 1 user users  202 Nov 17 11:48 persist.zip
    -rwxr-xr-x 1 user users   49 Nov 16 12:57 script 1.sh

    v2:
    drwxr-xr-x 2 user users 4096 Nov 16 14:44 .newdir
    drwxr-xr-x 2 user users 4096 Nov 16 13:58 subdir
    -rw-r--r-- 1 user users  225 Nov 16 13:05 .chang ed.zip
    -rw-r--r-- 1 user users  202 Nov 16 13:07 newbin.zip
    -rwxr-xr-x 1 user users   52 Nov 16 13:02 per sist.sh
    -rw-r--r-- 1 user users   31 Nov 16 12:55 persist.txt
    -rw-rw-rw- 1 user users  202 Nov 16 13:01 persist.zip
    -rwxr-xr-x 1 user users   53 Nov 16 13:05 script 1.sh


Authors and contact info
========================

Victor Selukov <victor [dot] selukov [at] gmail.com>

