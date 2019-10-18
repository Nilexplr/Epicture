#!/usr/bin/env sh

ssh-keyscan git.epitech.eu >> ~/.ssh/known_hosts
git checkout $TRAVIS_BRANCH
git push --repo=git@git.epitech.eu:/nicolas.garde@epitech.eu/DEV_epicture_2019 --force
