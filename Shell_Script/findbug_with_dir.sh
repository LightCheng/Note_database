#!/bin/bash

set -e
## Any subsequent commands which fail will cause the shell script to exit immediately
# $1 : target directory

### Variable definitions
script_path="$(readlink -f "${BASH_SOURCE[0]}")" # Absolute path to this script
script_dir="$(dirname "${script_path}")"         # Absolute path this script is in
script_file="$(basename "${script_path}")"       # Filename of this script

while getopts "h:" opt; do
  case $opt in
    h)
	echo "Set cci env 1st then run the sh from project root as below :"
	echo "findbug_with_dir.sh target_class_path aux_class_path"
	echo "example: ./ccienv/findbugs/findbug_with_dir.sh \`pwd\`/out/target/common/obj/APPS/Stk_intermediates/ \`pwd\`/out" 
      ;;
  esac
done

OUTBASE=${2}
OUTBASE=${OUTBASE:-"`pwd`/out"}
echo "Out base : ${OUTBASE}"


cd ${script_dir}

test -d findbugs_report && rm -rf findbugs_report
test -f script_dirall_logs.csv && rm -f all_logs.csv
test -f test_log_convert.csv && rm -f test_log_convert.csv
test -f auxclasspath.txt && rm -f auxclasspath.txt
test -f all_logs && rm -f all_logs

mkdir -p findbugs_report

# prepare the full AUXCLASSPATH list
find ${OUTBASE}/ -name 'classes-full-debug.jar' > auxclasspath.txt
echo "Total auxclass number :"
wc -l auxclasspath.txt | awk '{ print $1}'

white_module=($(cat whitelist.csv | sed -n 's/\(.*\),.*/\1/p'))

#echo ${1}
#Parameter1 is APK path , if P1 is empty or null string , scan all modules.
APKBASE=${1}
APKBASE=${APKBASE:-`echo ${OUTBASE}`}
echo "APK Base : ${APKBASE}"

for app_path in `find ${APKBASE} -name 'classes-full-debug.jar'`; do
   APK_NAME=`echo ${app_path}|sed  's/.*\/\(.*\)_intermediates\/classes-full-debug\.jar/\1/'`
   echo "apk name=[${APK_NAME}]"
   #Don't use whilte list , Scan all modules.
   java -jar lib/findbugs.jar -textui -auxclasspathFromFile auxclasspath.txt -exclude findbugs-cei-exclude.xml -output findbugs_report/${APK_NAME}.findbugs ${app_path}
done

unset OUTBASE
unset APKBASE

# 4. Fusing all the logs into one big table.
IFS=$'\n'
for fb_report in `find findbugs_report/ -name '*.findbugs'`; do
    echo "Processing: ${fb_report}" 
    apk_name=`echo ${fb_report}|sed 's/findbugs_report\/\(.*\)\.findbugs/\1/'`
    echo "apk_name: [${apk_name}]"

    group_name=$(grep -w "^${apk_name},.*" whitelist.csv | awk -F ',' '{ print $2 }')
    #echo "group_name: [${group_name}]"

    exec < ${fb_report}
    while read line
    do
        #Type , CEI Comment , APK name , Group name ...
        echo ${line}|sed -n "s/^\(.\) \(.\) \([^ .]\+:\) /\t\t${apk_name}\t${group_name}\t\1\t\2\t\3\t/p">> all_logs
    done
done

if [ -f all_logs ] ; then

perl ${script_dir}/CompareTool/texttocsv.pl ${script_dir}/all_logs
sort test_log_convert.csv > all_logs.csv
perl ${script_dir}/CompareTool/findbug_tool.pl all_logs.csv waive.csv 

fi
