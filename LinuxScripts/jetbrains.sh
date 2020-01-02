#	This script removes intellij idea and pycharm community editions and replaces
#	them with the corresponding licensed edition.

#!/bin/bash

sudo pacman -R intellij-idea-community-edition pycharm-community-edition
yay -S intellij-idea-ultimate-edition pycharm-professional && yay -P --stats
