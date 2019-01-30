#!/bin/bash

# Check that this looks like the GCHP directory
[ ! -d Shared/Linux ] && echo "This doesn't look like the GCHP directory!" && exit 1
[ ! -d ESMF/Linux ] && echo "This doesn't look like the GCHP directory!" && exit 1
[ ! -d Registry ] && echo "This doesn't look like the GCHP directory!" && exit 1

set -x
set -e

# Cleanup any leftover remnants of pkga
rm -rf pkg pkg.tar.gz
mkdir pkg
mkdir pkg/include
mkdir pkg/lib

# Function finds all files with a SUFFIX and copies them to DEST
scrape_dir() {
	DIR=$1
	SUFFIX=$2
	DEST=$3
	find $DIR -type f -name $SUFFIX | while read lib
	do 
		cp $lib $DEST
	done
}

# Scrape the ESMF build
scrape_dir "ESMF/Linux" '*.a'   "pkg/lib"
scrape_dir "ESMF/Linux" '*.mod' "pkg/include"
scrape_dir "ESMF/Linux" '*.h'   "pkg/include"
scrape_dir "ESMF/Linux" '*.inc' "pkg/include"

# Scrape the MAPL build
scrape_dir "Shared/Linux" '*.a'   "pkg/lib"
scrape_dir "Shared/Linux" '*.mod' "pkg/include"
scrape_dir "Shared/Linux" '*.h'   "pkg/include"
scrape_dir "Shared/Linux" '*.inc' "pkg/include"

# Scrape the Registry files
cp Registry/*.h pkg/include

# Make an archive of the contents
cd pkg
tar -czpvf ../scraped_gchp_thirdparty.tar.gz .
cd ..
rm -rf pkg
