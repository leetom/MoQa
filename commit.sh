#!/usr/bash
# 20130301 1:00 lua

mysqldump -uroot -p moqa > moqa.sql 

git add -A

git commit

git push
