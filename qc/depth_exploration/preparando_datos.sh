# notron 
cd /mnt/d/hachepunto/qualimap/qualimap/depthFiles
# rotundellus
cd /Users/hachepunto/mnt/notron/mnt/d/hachepunto/qualimap/qualimap/depthFiles
# indra
cd notron/mnt/d/hachepunto/qualimap/qualimap/depthFiles

find ../ -name coverage_across_reference.txt | awk -F "/" '{print "ln -s ." $0 " ./" $2 ".tsv"}' | bash