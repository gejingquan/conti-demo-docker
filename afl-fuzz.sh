#!/bin/bash
#for i in $(seq 1 $1); do /AFL/afl-fuzz -i ./vol/in -o ./vol/out -M fuzzer$i ./vol/fuzzgoat @@; done
#/AFL/afl-fuzz -i ./vol/$1 -o ./vol/out -M fuzzer$3 ./vol/$2 @@
#/AFL/afl-fuzz -i /AFL/vol/$1 -o /AFL/vol/$4/out -M fuzzer$3 ./$2 @@
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

#check if dictionary file has been provided
if [ -z "$job_dictionary" ]
then
     #AFL command to run without dictionary option
     echo "\$job_dictionary is empty"
     # ./afl-fuzz -i ./vol/$job_corpus -o ./vol/$job_name/out -M fuzzer$job_parallel_threads ./vol/$job_name/$job_fuzz_target_name @@
     echo ./afl-fuzz -i $job_corpus -o $job_output -S $job_fuzzer_identifier -m none $job_fuzz_target_path @@
     ./afl-fuzz -i $job_corpus -o $job_output -S $job_fuzzer_identifier -m none $job_fuzz_target_path @@
else
      #AFL command to run with dictionary option -x
      echo "\$job_dictionary is NOT empty"
      echo LD_LIBRARY_PATH=/AFL/vol/lib ./afl-fuzz -i $job_corpus -o $job_output -x $job_dictionary -S $job_fuzzer_identifier -m none $job_fuzz_target_path @@
      LD_LIBRARY_PATH=/AFL/vol/lib ./afl-fuzz -i $job_corpus -o $job_output -x $job_dictionary -S $job_fuzzer_identifier -m none $job_fuzz_target_path @@
fi

#pathing in container
#AFL/vol/test_AFL_2021_08_17_10_15_59/out/
