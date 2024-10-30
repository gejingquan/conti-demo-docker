AURORA_GIT_DIR="$(pwd)/aurora"
cd evaluation
EVAL_DIR=`pwd`
AFL_DIR=$EVAL_DIR/afl-fuzz
AFL_WORKDIR=$EVAL_DIR/afl-workdir
export PIN_ROOT="$(pwd)/pin-3.15-98253-gb56e429b1-gcc-linux"


rm -rf  $EVAL_DIR/traces/*
rm -rf  /tmp/tm
cd $EVAL_DIR
rm -rf addresses.json  mnemonics.json predicates.json ranked_predicates.txt ranked_predicates_verbose.txt rankings.json scores_linear.csv scores_linear_serialized.json



cd $AURORA_GIT_DIR/tracing/scripts
python3 tracing.py $EVAL_DIR/binary_trace $EVAL_DIR/inputs $EVAL_DIR/traces
python3 addr_ranges.py --eval_dir $EVAL_DIR $EVAL_DIR/traces

cd $AURORA_GIT_DIR/root_cause_analysis
cargo clean
cargo build --release --bin monitor
cargo build --release --bin rca
cargo run --release --bin rca -- --eval-dir $EVAL_DIR --trace-dir $EVAL_DIR --monitor --rank-predicates
cargo run --release --bin addr2line -- --eval-dir $EVAL_DIR



