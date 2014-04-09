#!/bin/bash
# HEVC encoder test script.
# Assumes *nix-like environment (originally implemented to be run cygwin)

# Configuration variables. #####################################################
# Path to test .yuv files. 
_yuv_files="./yuv/*"

# Path to HM HEVC encoder.
_hm_hevc_encoder="/cygdrive/c/Users/Marko/HM_HEVC/bin/vc10/Win32/Debug/TAppEncoder.exe"

# Path to HM HEVC configuration files.
_hm_hevc_cfg="./cfg/hm_hevc/"

# Path to HM HEVC output folder.
_hm_hevc_out="./out/hm_hevc"

_results_dir="./results"

# Path to HM HEVC non-file-specific config file.
_hm_hevc_global_cfg="./cfg/hm_hevc/encoder_randomaccess_main10.cfg"

# Path to x.265 configuration files.
_x265_cfg="./cfg/x265/"

# Target quantization parameter values.
declare -a _qps=("50" "32" "27")

# /Configuration variables. ####################################################



# Echo to output file.
record() {

	echo $1 >> $2
}




# Encode a .yuv file using the HM HEVC implementation and write the results to
# an appropriate file. 
# @param $1 - The path to the .yuv file to be encoded.
hm_hevc_test() {


	results_file="$_results_dir/hm_hevc_results.txt"

	record "------------ Testing HEVC Reference Implementation ------------" $results_file
	record "" $results_file	

	# Get filename from $1
	tmp=$(echo $1 | awk -F\\ '{print $(NF)}')
	filename=$(echo $tmp | awk -F/ '{print $(NF)}')

	# We have to find the appropriate configuration file.
	# By convention we have that the name of the config file will be the
	# same as the .yuv video it is meant to test but with the appropriate
	# extension (.cfg)
	name=$(echo $filename | cut -d . -f 1)
	cfg=$_hm_hevc_cfg$name.cfg

	# Iterate over all target bitrates.
	for QP in "${_qps[@]}"
	do

		# Specify new bitrate in the configuration file.
		sed -i "s/\(QP[[:space:]]*:[[:space:]]*\).*/\1$QP/" $cfg		
		# Specify the name and location of the output file to be generated.
		bin_out=$_hm_hevc_out$name.bin

		rec_out="$_hm_hevc_out$name""_rec.yuv"

		echo $rec_out
		echo $bin_out

		cat $cfg 

		exec_str="$_hm_hevc_encoder -i $1 -o $rec_out -b $bin_out -c $cfg -c $_hm_hevc_global_cfg"

		# Start timer.
		#START=$(data +%s.%N)

		eval "$exec_str" >> $results_file

		# End timer.
		#END=$(date +%s.%N)

		#RUN_TIME=$(echo "$END - $START" | bc)
		#record $RUN_TIME $results_file

		record "---------------------------------------------------------------" $results_file
	done
} 

# Iterate over all test files.
for f in $_yuv_files; 
do
	# TODO: ensure that the extension of the file is .yuv
	hm_hevc_test $f
done
