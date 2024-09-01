# The whole AFL is built on ubuntu 20.04
FROM ubuntu:focal

MAINTAINER Jingquan Ge <gejingquan1986823@gmail.com>
# ENV http_proxy "http://uib13471:Conti2020!@cias3basic.conti.de:8080"
# ENV https_proxy "http://uib13471:Conti2020!@cias3basic.conti.de:8080"
# install git
RUN apt-get update &&  apt-get -y install git
# install gcc
RUN apt -y install build-essential
RUN apt-get -y install manpages-dev
# install vim
RUN apt-get -y install vim

# Fix for installing tzdata
ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install boost
RUN apt-get install -q -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get -qq update && apt-get install -qy g++ gcc git wget
RUN wget --max-redirect 20 https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz
RUN mkdir -p /usr/include/boost && tar zxf boost_1_71_0.tar.gz -C /usr/include/boost --strip-components=1
# install libclang: TDO

# git clone afl from github and run
RUN git clone --depth 2 --branch v2.57b https://github.com/google/AFL.git
RUN echo "you already download afl in your container"

# install afl
# RUN cd AFL
WORKDIR /AFL
# overwrite the default afl-fuzz
COPY ./afl-fuzz.c /AFL
RUN apt-get -y install make
RUN make
RUN echo "you succeffuly install afl"

# link in folder and fuzzing target into volume
RUN mkdir vol

# RUN export "AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1"
# CMD export "AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1";./afl-fuzz -i ./vol/in -o ./vol/out ./vol/fuzzgoat @@
# copy shell script in container
COPY ./afl-fuzz.sh /AFL
COPY ./afl-plot /AFL
COPY ./afl-fuzz /AFL
RUN chmod u+x afl-fuzz.sh
RUN chmod g+x afl-fuzz.sh
RUN chmod o+x afl-fuzz.sh
RUN chmod u+x afl-fuzz
RUN chmod g+x afl-fuzz
RUN chmod o+x afl-fuzz
RUN chmod u+x afl-plot
RUN chmod g+x afl-plot
RUN chmod o+x afl-plot

ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
ENV AFL_SKIP_CPUFREQ=1
RUN sleep 5

# run the shell script to start AFL fuzzing process
CMD ["/AFL/afl-fuzz.sh"]

# we could pass in the num to differentiate fuzzers
# ENTRYPOINT ["/AFL/afl-fuzz.sh"]



RUN apt-get -y install ruby-full
RUN apt-get -y install bison
WORKDIR /aurora

COPY ./RCA_v1_installation.sh /aurora
RUN chmod u+x RCA_v1_installation.sh
RUN chmod g+x RCA_v1_installation.sh
RUN chmod o+x RCA_v1_installation.sh

COPY ./NormalFuzz.sh /aurora
RUN chmod u+x NormalFuzz.sh
RUN chmod g+x NormalFuzz.sh
RUN chmod o+x NormalFuzz.sh

COPY ./RCAfuzz.sh /aurora
RUN chmod u+x RCAfuzz.sh
RUN chmod g+x RCAfuzz.sh
RUN chmod o+x RCAfuzz.sh


COPY ./jingquan-filter.patch    /aurora
COPY ./jingquan-analyzer.patch  /aurora

RUN /aurora/RCA_v1_installation.sh

WORKDIR /AFL

