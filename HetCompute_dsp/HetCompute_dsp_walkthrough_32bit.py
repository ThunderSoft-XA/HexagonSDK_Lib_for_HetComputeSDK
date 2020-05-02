
# child python script

### Imports ###
import os		# provide output to command prompt
import signal	# allow communication between child and parent processes
import time		# delay functions
import sys		# flush command prompt output
from sys import platform as _platform
import argparse
import re
from argparse import RawTextHelpFormatter

pid = os.getpid()	# return the current process ID
received = False	# initialize signal received to false

target_info = ["8998","8996","sdm660","sdm845",]

#******************************************************************************
# Parser for cmd line options
#******************************************************************************
parser = argparse.ArgumentParser(prog='calculator_walkthrough.py', description=__doc__, formatter_class=RawTextHelpFormatter)
parser.add_argument("-L", dest="linux_env", action="store_true", help="build for the Linux platform") 
parser.add_argument('-T', dest="target", help="specify target name  <8998, 8996, sdm660, sdm845>")
parser.add_argument('-D', dest="dsp_image", default="True", help="specify subsystem to run on <cdsp, adsp, mdsp, slpi>")
parser.add_argument('-V', dest="hex_version", default="True", help="specify heagon version example : v81_v65")

options = parser.parse_args()

# signal handler
def signal_usr1(signum, frame):	# signum is signal used to call handler 'signal_usr1', frame is current stack frame
	print "Exiting..."			# print appropriate message
	sys.stdout.flush()			# flush output to command prompt
	sys.exit(0)					# exit child process

def print_and_run_cmd(cmd):
	print cmd
	if os.system(cmd) != 0 : sys.exit(2) # in error stop execution and exit

# run HetCompute_dsp
def run_calc():
	if not os.getenv('SDK_SETUP_ENV'):
		sys.exit("\nSDK Environment not set up -> please run setup_sdk_env script from SDK's root directory.")

	target_name=""
	for target_name in target_info:
		if options.target==target_name: 
			break
		else : target_name=""
	if target_name=="" : 
		print "Error! Target name is not in list \nPlease pass -T with below supported targets :"
		for target_name in target_info: print "\t"+target_name
		sys.exit()

	
	#If -L specified, UbuntuARM_Debug_aarch64
	variant="android_Debug"
	if options.linux_env :
		variant="UbuntuARM_Debug_aarch64"
		if options.target == "sdm660" :
			print options.target + " target won't support LE"
			sys.exit()
	HEXAGON_SDK_ROOT=os.getenv('HEXAGON_SDK_ROOT')

	#parsing the subsystem Falg 
	Flag ="" #by default adsp is picked
	if options.target == "sdm660":
		hex_variant="hexagon_Debug_dynamic_toolv81_v62"
	elif options.target == "sdm845":
		hex_variant="hexagon_Debug_dynamic_toolv81_v65"
	elif options.target == "8998":
		hex_variant="hexagon_Debug_dynamic_toolv81_v62"
	elif options.target == "8996":
		hex_variant="hexagon_Debug_dynamic_toolv72_v60"

	#parsing the subsystem Falg 
	if "True" != options.dsp_image:
		if options.dsp_image == "slpi":
			Flag = "SLPI_FLAG=1"
			if options.linux_env and options.target == "8996" :
					print options.target + " LE target won't support SLPI"
					sys.exit()
			if options.target == "sdm660" or options.target == "8996":
				print options.target + " target won't support SLPI"
				sys.exit()
		elif options.dsp_image == "cdsp":
			Flag = "CDSP_FLAG=1"
			if options.linux_env and (options.target == "8996" or options.target == "8998"):
					print options.target + " LE target won't support CDSP"
					sys.exit()
			if options.target == "sdm660":
				hex_variant="hexagon_Debug_dynamic_toolv81_v60"
			elif options.target == "8996" or options.target == "8998":
				print options.target +" target won't support CDSP"
				sys.exit()
		elif options.dsp_image == "mdsp":
			Flag = "MDSP_FLAG=1"
			if options.target == "8996":
				hex_variant="hexagon_Debug_dynamic_toolv72_v55"
		elif options.dsp_image == "adsp":
			Flag = ""
		else:
			print "Error! unknown -D <argument> \nsupport arg: \n\tadsp, mdsp, slpi, cdsp\n"
			sys.exit()

	#parsing the subsystem Falg 
	if "True" != options.hex_version:
		regex = 'v\d+_v\d+'
		m = re.match(regex, options.hex_version)
		if m is None:
			print "Error! unknown Hexgon version please give like below \nexample : v81_v65"
			sys.exit()
		hex_variant="hexagon_Debug_dynamic_tool"+options.hex_version

	print "hex_variant = "+hex_variant
	print_and_run_cmd('adb logcat -c')

	ANDROID_ROOT_DIR=os.getenv('ANDROID_ROOT_DIR')
	if ANDROID_ROOT_DIR == None:
		ANDROID_ROOT_DIR=HEXAGON_SDK_ROOT+'/tools/android-ndk-r10d'

	calculator_exe='{}/examples/common/HetCompute_dsp/{}/ship/hetcompute_dsp'.format(HEXAGON_SDK_ROOT,variant)
	libhetcompute_dsp_skel='{}/examples/common/HetCompute_dsp/{}/ship/libhetcompute_dsp_skel.so'.format(HEXAGON_SDK_ROOT,hex_variant)
	libhetcompute_dsp='{}/examples/common/HetCompute_dsp/{}/ship/libhetcompute_dsp.so'.format(HEXAGON_SDK_ROOT,variant)
	libgnustl=ANDROID_ROOT_DIR+'/sources/cxx-stl/gnu-libstdc++/4.9/libs/arm64-v8a/libgnustl_shared.so'
	
	print "---- Build HetCompute_dsp example for both Android and Hexagon ----"
	if _platform == "win32":
		clean_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree_clean V='+variant+' '+Flag+' VERBOSE=1 || exit /b'
		build_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree V='+variant+' '+Flag+' VERBOSE=1  || exit /b'
		clean_hexagon_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree_clean V='+hex_variant+' VERBOSE=1 || exit /b'
		build_hexagon_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree V='+hex_variant+' VERBOSE=1 || exit /b'
	else:
		clean_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree_clean V='+variant+' '+Flag+' VERBOSE=1  || exit 1'
		build_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree V='+variant+' '+Flag+' VERBOSE=1  || exit 1'
		clean_hexagon_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree_clean V='+hex_variant+' VERBOSE=1 || exit 1'
		build_hexagon_variant = 'make -C ' + HEXAGON_SDK_ROOT + '/examples/common/HetCompute_dsp tree V='+hex_variant+' VERBOSE=1 || exit 1'

	call_test_sig='python '+ HEXAGON_SDK_ROOT+'/scripts/testsig.py'
	APPS_DST='/vendor/bin'
	DSP_DST='/vendor/lib/rfsa/adsp/'
	LIB_DST='/vendor/lib'
	ADSP_LIB_PATH="/system/lib/rfsa/adsp:/vendor/lib/rfsa/adsp:/dsp;"
	if options.linux_env :
		call_test_sig='python '+ HEXAGON_SDK_ROOT+'/scripts/testsig.py -LE'
		APPS_DST='/data'
		DSP_DST='/usr/lib/rfsa/adsp/'
		LIB_DST='/usr/lib64'
		ADSP_LIB_PATH="/usr/lib/rfsa/adsp:/dsp;"

	print_and_run_cmd(clean_variant)
	print_and_run_cmd(build_variant)
	print_and_run_cmd(clean_hexagon_variant)
	print_and_run_cmd(build_hexagon_variant)
	os.system(call_test_sig)
	
	print "---- root/remount device ----"
	print_and_run_cmd('adb wait-for-device root')
	print_and_run_cmd('adb wait-for-device remount')
	
	print "---- Push Android components ----"
	print_and_run_cmd('adb wait-for-device shell mkdir -p '+APPS_DST)	
	print_and_run_cmd('adb wait-for-device push '+calculator_exe+' '+APPS_DST)
	print_and_run_cmd('adb wait-for-device shell chmod 777 '+APPS_DST+'/hetcompute_dsp')
	print_and_run_cmd('adb wait-for-device push '+libgnustl+' '+LIB_DST)
	print_and_run_cmd('adb wait-for-device push '+libhetcompute_dsp+' '+LIB_DST)

	print "---- Push Hexagon Components ----"
	print_and_run_cmd('adb wait-for-device shell mkdir -p '+DSP_DST)
	print_and_run_cmd('adb wait-for-device push '+libhetcompute_dsp_skel+' '+DSP_DST)

	print "---- Direct dsp messages to logcat ---"
	print_and_run_cmd('adb wait-for-device shell "echo 0x1f > '+DSP_DST+'HetCompute_dsp.farf"')
	# print_and_run_cmd('adb wait-for-device reboot')	
	print_and_run_cmd('adb wait-for-device')

	if _platform == "win32":
		print "---- Launch logcat window to see aDSP diagnostic messages"
		print_and_run_cmd('start cmd.exe /c adb logcat -s adsprpc')
		print_and_run_cmd('sleep 2')
	else:
		ADSP_LIB_PATH="\'/system/lib/rfsa/adsp:/vendor/lib/rfsa/adsp:/dsp;\'"
		if options.linux_env : ADSP_LIB_PATH="\'/usr/lib/rfsa/adsp:/dsp;\'"
		print_and_run_cmd('sleep 2')

	print "---- Run calculator_plus Example ----"
	print_and_run_cmd('adb wait-for-device shell ADSP_LIBRARY_PATH='+ADSP_LIB_PATH+' '+APPS_DST+'/hetcompute_dsp')
	print "Done"

# main entry point for child process
if __name__ == '__main__':
	signal.signal(signal.SIGINT, signal_usr1)				# register signal handler 'signal.SIGINT' to function handler 'signal_usr1'
	run_calc()												# call function to initialize debug_agent
	sys.stdout.flush()										# show output immediately in command prompt

