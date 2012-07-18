#!/bin/sh
# Copyright (C) 2007, Thomas Treichl and Paul Kienzle
# Copyright (C) 2008-2011, Thomas Treichl
# Copyright (C) 2012, Ben Abbott
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; If not, see <http://www.gnu.org/licenses/>.


if [[ $OSTYPE = "darwin9.0" ]]; then
  exit
elif [[ $OSTYPE = "darwin10.0" ]]; then
  open -a Terminal "/usr/bin/grython"
elif [[ $OSTYPE = "darwin11" ]]; then
  open -F -a Terminal "/usr/bin/grython"
else
  open -F -a Terminal "/usr/bin/grython"
fi
