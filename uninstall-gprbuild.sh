#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                         GPRBUILD UNINSTALLER                             --
# --                                                                          --
# --         Copyright (C) 2025 Mario Blunk, Blunk electronic                 --
# --                                                                          --
# --    This program is free software: you can redistribute it and/or modify  --
# --    it under the terms of the GNU General Public License as published by  --
# --    the Free Software Foundation, either version 3 of the License, or     --
# --    (at your option) any later version.                                   --
# --                                                                          --
# --    This program is distributed in the hope that it will be useful,       --
# --    but WITHOUT ANY WARRANTY; without even the implied warranty of        --
# --    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
# --    GNU General Public License for more details.                          --
# --                                                                          --
# --    You should have received a copy of the GNU General Public License     --
# --    along with this program.  If not, see <http://www.gnu.org/licenses/>. --
# ------------------------------------------------------------------------------
# 
# --   For correct displaying set tab width in your editor to 4.
# 
# --   The two letters "CS" indicate a "construction site" where things are not
# --   finished yet or intended for the future.
# 
# --   Please send your questions and comments to:
# --
# --   info@blunk-electronic.de
# --   or visit <http://www.blunk-electronic.de> for more contact information
# --
# --   history of changes:
# --


# exit this script on error:
set -e

# release=25.0.0
# release_prefix=v$release

rm -rf /usr/libexec/gprbuild
rm -rf /usr/share/gprconfig

rm /usr/bin/gprbuild
rm /usr/bin/gprconfig
rm /usr/bin/gprclean
rm /usr/bin/gprinstall
rm /usr/bin/gprls
rm /usr/bin/gprname
rm /usr/bin/gprslave


exit


