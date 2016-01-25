#! /bin/sh

echo Hello world!
var=2
if [ -z ${2+x} ]
 then echo "var is unset"
 else echo "var is set to '$1'"
fi

