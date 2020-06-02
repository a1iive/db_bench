export TEST_TMPDIR=/home/hhs/WT_bench
NUM=100000000
# some engines appear to ignore the cache_size and just grab as much RAM as they want
CACHE="`expr 128 \* 1024 \*1024`"
# some engines honor the cache_size, give them more.
CACHE2="`expr 128 \* 1024 \*1024`"
WRATE=30000
STATS=1048576
DUR=600
TIME="/usr/bin/time -v"

export LD_LIBRARY_PATH=$WT_HOME/lib:$LD_LIBRARY_PATH
rm -rf $TEST_TMPDIR/*
echo "Running wiredtiger twice, once as LSM, once as Btree"
rm -rf $TEST_TMPDIR/*
LD_PRELOAD=/usr/lib64/libjemalloc.so LD_LIBRARY_PATH=$WT_HOME/lib:$LD_LIBRARY_PATH $TIME ./db_bench_wiredtiger --stats_interval=$STATS --cache_size=$CACHE --num=$NUM --benchmarks=fillseqbatch
#for THREADS in 1 2 4 8 16 32 64; do
for THREADS in 1 4 16 32; do
echo THREADS=$THREADS
LD_PRELOAD=/usr/lib64/libjemalloc.so LD_LIBRARY_PATH=$WT_HOME/lib:$LD_LIBRARY_PATH $TIME ./db_bench_wiredtiger --stats_interval=$STATS --cache_size=$CACHE --num=$NUM --benchmarks=readwhilewriting --use_existing_db=1 --writes_per_second=$WRATE --threads=$THREADS --duration=$DUR
du $TEST_TMPDIR
done
echo "Running wiredtiger Btree"
rm -rf $TEST_TMPDIR/*
LD_PRELOAD=/usr/lib64/libjemalloc.so LD_LIBRARY_PATH=$WT_HOME/lib:$LD_LIBRARY_PATH $TIME ./db_bench_wiredtiger --stats_interval=$STATS --cache_size=$CACHE2 --num=$NUM --use_lsm=0 --benchmarks=fillseqbatch
#for THREADS in 1 2 4 8 16 32 64; do
for THREADS in 1 4 16 32; do
echo THREADS=$THREADS
LD_PRELOAD=/usr/lib64/libjemalloc.so LD_LIBRARY_PATH=$WT_HOME/lib:$LD_LIBRARY_PATH $TIME ./db_bench_wiredtiger --stats_interval=$STATS --cache_size=$CACHE2 --num=$NUM --use_lsm=0 --benchmarks=readwhilewriting --use_existing_db=1 --writes_per_second=$WRATE --threads=$THREADS --duration=$DUR
du $TEST_TMPDIR
done
exit