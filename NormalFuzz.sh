#!/bin/bash

job_corpus=$1
job_fuzz_target_path=$2
job_parallel_threads=$3
job_name=$4
job_output=$5
job_fuzzer_identifier=$6
job_dictionary=$7

echo ==============================================
echo job_corpus is            :$job_corpus
echo job_fuzz_target_path is  :$job_fuzz_target_path
echo job_parallel_threads is  :$job_parallel_threads
echo job_name is              :$job_name
echo job_output is            :$job_output
echo job_fuzzer_identifier    :$job_fuzzer_identifier
echo job_dictionary is        :$job_dictionary
echo ==============================================


AURORA_GIT_DIR="/aurora/aurora"
EVAL_DIR="/aurora/evaluation"
AFL_DIR="/aurora/evaluation/afl-fuzz"
AFL_WORKDIR="/aurora/evaluation/afl-workdir"
export PIN_ROOT="/aurora/evaluation/pin-3.15-98253-gb56e429b1-gcc-linux"


echo normal AFL mruby start!
#check if dictionary file has been provided
if [ -z "$job_dictionary" ]
then
     #AFL command to run without dictionary option
     echo "\$job_dictionary is empty"
     # ./afl-fuzz -i ./vol/$job_corpus -o ./vol/$job_name/out -M fuzzer$job_parallel_threads ./vol/$job_name/$job_fuzz_target_name @@

     echo LD_LIBRARY_PATH=/AFL/2025.01.01_coverage_afl-g++/all ./afl-fuzz -i $job_corpus -o $job_output -S $job_fuzzer_identifier -m none  $EVAL_DIR/binary_fuzz @@
     LD_LIBRARY_PATH=/AFL/2025.01.01_coverage_afl-g++/all /AFL/afl-fuzz -i $job_corpus -o $job_output -S $job_fuzzer_identifier -m none $EVAL_DIR/binary_fuzz @@
else
      #AFL command to run with dictionary option -x
      echo "\$job_dictionary is NOT empty"
      echo ./afl-fuzz -i $job_corpus -o $job_output -x $job_dictionary -S $job_fuzzer_identifier -m none  $EVAL_DIR/binary_fuzz @@
      LD_LIBRARY_PATH=/AFL/2025.01.01_coverage_afl-g++/all /AFL/afl-fuzz -i $job_corpus -o $job_output -x $job_dictionary -S $job_fuzzer_identifier -m none $EVAL_DIR/binary_fuzz @@
fi
echo normal AFL mruby over!


