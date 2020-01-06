#!/bin/bash

for dir in /home/students/*/
do
	cd $dir
	echo $dir
	rm -rf .PyCharm2019.2 .IntelliJIdea2019.2 .CLion2019.2
	cd /home
done

