---
layout: post
title: Creating a Rails 3.1 App on GitHub
---

New draft post


Create repository on GitHub account
git config --global user.name "Will Riker"
git config --global user.email "riker@starfleet.net"

rails new EnterpriseApp
cd EnterpriseApp
git init
mv README README_RAILS
echo "EnterpriseApp" > README
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:riker/EnterpriseApp.git
git push -u origin master

