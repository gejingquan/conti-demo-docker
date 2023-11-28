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

#echo core >/proc/sys/kernel/core_pattern
#echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#echo 0 | tee /proc/sys/kernel/randomize_va_space

timeout 20000 $AFL_DIR/afl-fuzz -C -m none -i $job_corpus -o $job_output   -S $job_fuzzer_identifier -- $job_fuzz_target_path @@


