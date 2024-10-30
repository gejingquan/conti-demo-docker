#!/bin/bash


git clone https://github.com/RUB-SysSec/aurora
AURORA_GIT_DIR="$(pwd)/aurora"
mkdir evaluation
cd evaluation
EVAL_DIR=`pwd`
AFL_DIR=$EVAL_DIR/afl-fuzz
AFL_WORKDIR=$EVAL_DIR/afl-workdir
mkdir -p $EVAL_DIR/inputs/crashes
mkdir -p $EVAL_DIR/inputs/non_crashes


wget -c https://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar xvf afl-latest.tgz
mv afl-2.52b afl-fuzz
cd afl-fuzz
patch -p1 < ${AURORA_GIT_DIR}/crash_exploration/crash_exploration.patch
#patch -p1 < ../../RCA_v1/jingquan-filter.patch
#cd ../../aurora/root_cause_analysis
#patch -p1 < ../../RCA_v1/jingquan-analyzer.patch
cd $EVAL_DIR/afl-fuzz
make -j
cd ..


git clone https://github.com/mruby/mruby.git
cd mruby
git checkout e9ddb593f3f6c0264563eaf20f5de8cf43cc1c5d
CC=$AFL_DIR/afl-gcc CFLAGS="-fsanitize=address -fsanitize-recover=address -ggdb -O0" LDFLAGS="-fsanitize=address"  make -e -j
mv ./bin/mruby ../binary_fuzz
make clean
CFLAGS="-ggdb -O0" make -e -j
mv ./bin/mruby ../binary_trace
cd $EVAL_DIR
#rm -rf binary_fuzz binary_trace
echo "@@" > arguments.txt



wget -c http://software.intel.com/sites/landingpage/pintool/downloads/pin-3.15-98253-gb56e429b1-gcc-linux.tar.gz
tar -xzf pin*.tar.gz
export PIN_ROOT="$(pwd)/pin-3.15-98253-gb56e429b1-gcc-linux"
mkdir -p "${PIN_ROOT}/source/tools/AuroraTracer"
cp -r ${AURORA_GIT_DIR}/tracing/* ${PIN_ROOT}/source/tools/AuroraTracer
cd ${PIN_ROOT}/source/tools/AuroraTracer
make obj-intel64/aurora_tracer.so
cd -
mkdir -p $EVAL_DIR/traces



