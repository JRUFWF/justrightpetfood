#!/bin/bash

################ 1: Get lighthouse
npm install -g lighthouse

################ 1: Get lighthouse desktop report
lighthouse https://justrightpetfood.local  --output html --preset=desktop --disable-network-throttling=true --disable-storage-reset=true

################ 1: Get lighthouse mobile report
lighthouse https://justrightpetfood.local  --output html --preset=mobile --disable-network-throttling=true --disable-storage-reset=true


