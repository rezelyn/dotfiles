#!/usr/bin/env bash
playerctl --follow metadata --format '{{ artist }} - {{ title }}' 2>/dev/null
