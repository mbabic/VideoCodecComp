#!/bin/bash
# HEVC encoder test script.
# Assumes *nix-like environment (originally implemented to be run cygwin)

# Path to test .yuv files. 
_yuv_files="/cygdrive/c/Users/Marko/VideoCodecComp/*"

# Path to HM HEVC encoder.
_hm_hevc_encoder="/cygdrive/c/Users/Marko/HM_HEVC/bin/vc10/Win32/Debug/TAppEncoder.exe"

# Path to HM HEVC configuration files.
_hm_hevc_cfg="./cfg/hm_hevc/"

# Path to HM HEVC non-file-specific config file.
_hm_hevc_global_cfg="./cfg/hm_hevc/encoder_randomaccess_main10.cfg"

# Path to x.265 configuration files.
_x265_cfg="./cfg/x265/"

# Encode a .yuv file using the HM HEVC implementation and write the results to
# an appropriate file. 
# @param $1 - The path to the .yuv file to be encoded.
hm_hevc_test() {

	echo "------------ Testing HEVC Reference Implementation ------------"
	echo ""	
	
	# Get filename from $1
	tmp=$(echo $1 | awk -F\\ '{print $(NF)}')
	filename=$(echo $tmp | awk -F/ '{print $(NF)}')

	# We have to find the appropriate configuration file.
	# By convention we have that the name of the config file will be the
	# same as the .yuv video it is meant to test but with the appropriate
	# extension (.cfg)
	cfg_name=$(echo $filename | cut -d . -f 1)
	cfg=$_hm_hevc_cfg$cfg_name.cfg

	echo $1

	exec_str="$_hm_hevc_encoder -i $1 -c $cfg -c $_hm_hevc_global_cfg"

	#eval "$exec_str"

} 

# Iterate over all test files.
for f in $_yuv_files; 
do
	echo $f
	if [[ "$f" =~ *\.yuv ]]; then
		echo "matched"
		hm_hevc_test $f
	fi
done
