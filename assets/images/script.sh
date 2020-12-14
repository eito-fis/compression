#!/bin/bash
for f in */*
do
	magick convert $f -transparent "#ffffff" $f
done
