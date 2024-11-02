AURORA_GIT_DIR="$(pwd)/aurora"
cd evaluation
EVAL_DIR=`pwd`
AFL_DIR=$EVAL_DIR/afl-fuzz
AFL_WORKDIR=$EVAL_DIR/afl-workdir
export PIN_ROOT="$(pwd)/pin-3.15-98253-gb56e429b1-gcc-linux"


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


rm -rf  $EVAL_DIR/binary_fuzz
rm -rf  $EVAL_DIR/binary_trace
rm -rf  $EVAL_DIR/inputs/crashes/*
rm -rf  $EVAL_DIR/inputs/non_crashes/*
rm -rf  $EVAL_DIR/traces/*
rm -rf  /tmp/tm
cd $EVAL_DIR
rm -rf addresses.json  mnemonics.json predicates.json ranked_predicates.txt ranked_predicates_verbose.txt rankings.json scores_linear.csv scores_linear_serialized.json

cp -r $job_corpus/crashes       $EVAL_DIR/inputs/
cp -r $job_corpus/non_crashes   $EVAL_DIR/inputs/
cp $job_fuzz_target_path        $EVAL_DIR/binary_trace

cd $AURORA_GIT_DIR/tracing/scripts
python3 tracing.py $EVAL_DIR/binary_trace $EVAL_DIR/inputs $EVAL_DIR/traces
python3 addr_ranges.py --eval_dir $EVAL_DIR $EVAL_DIR/traces

cd $AURORA_GIT_DIR/root_cause_analysis
cargo clean
cargo build --release --bin monitor
cargo build --release --bin rca
cargo run --release --bin rca -- --eval-dir $EVAL_DIR --trace-dir $EVAL_DIR --monitor --rank-predicates
cargo run --release --bin addr2line -- --eval-dir $EVAL_DIR

cp  $EVAL_DIR/ranked_predicates_verbose.txt  $job_output


