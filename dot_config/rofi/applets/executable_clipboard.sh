#!/usr/bin/env bash

cliphist list | rofi -dmenu -theme clipboard.rasi | cliphist decode | wl-copy 
