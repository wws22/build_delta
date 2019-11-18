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
and installed xdelta package <http://xdelta.org/>

.. code-block:: bash

    Usage: build_delta.sh <ver1dir> <ver2dir> <target_name>


Authors and contact info
========================

Victor Selukov <victor [dot] selukov [at] gmail.com>

