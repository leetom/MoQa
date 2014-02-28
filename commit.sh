#!/usr/bash

mysqldump -uroot -p moqa > moqa.sql 

git add -A

git commit

git push
