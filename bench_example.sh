#! /bin/sh

db_path="/home/hhs/WT_bench"

# key_size="16"
value_size="16"

# benchmarks="fillrandom,stats,readrandom,stats,rangerandom,stats,updaterandom,stats,deleterandom" 
benchmarks="fillrandom,readrandom,rangerandom,updaterandom,deleterandom" 

#num="1000000"  #
num="10000000"  #1千万，0.32G
# num="100000000"  #1亿，3.2G
#num="1000000000"  #10亿，32G
#num="10000000000"  #100亿，320G

cache_size="`expr 128 \* 1024 \* 1024`"

#reads="1000000"
reads="10000000"  #读取固定1千万条
deletes="10000000" #删除1千万条
updates="10000000" #修改1千万条

threads="4"
use_lsm="0"

batch_size="100"
#bloom_bits="10"

seek_nexts="20"
direct_io="0"

stats_type="0"
const_params=""

function FILL_PATAMS() {
    if [ -n "$db_path" ];then
        const_params=$const_params"--db=$db_path "
    fi

    if [ -n "$value_size" ];then
        const_params=$const_params"--value_size=$value_size "
    fi

    if [ -n "$benchmarks" ];then
        const_params=$const_params"--benchmarks=$benchmarks "
    fi

    if [ -n "$nums" ];then
        const_params=$const_params"--num=$num "
    fi

    if [ -n "$reads" ];then
        const_params=$const_params"--reads=$reads "
    fi

    if [ -n "$deletes" ];then
        const_params=$const_params"--deletes=$deletes "
    fi
    
    if [ -n "$updates" ];then
        const_params=$const_params"--updates=$updates "
    fi

    if [ -n "$seek_nexts" ];then
        const_params=$const_params"--seek_nexts=$seek_nexts "
    fi

    if [ -n "$threads" ];then
        const_params=$const_params"--threads=$threads "
    fi

    if [ -n "$bloom_bits" ];then
        const_params=$const_params"--bloom_bits=$bloom_bits "
    fi

    if [ -n "$batch_size" ];then
        const_params=$const_params"--batch_size=$batch_size "
    fi
    
    if [ -n "$direct_io" ];then
        const_params=$const_params"--direct_io=$direct_io "
    fi

    if [ -n "$use_lsm" ];then
        const_params=$const_params"--use_lsm=$use_lsm "
    fi

    if [ -n "$stats_type" ];then
        const_params=$const_params"--stats_type=$stats_type "
    fi

}


bench_file_path="$(dirname $PWD )/db_bench_wiredtiger"

if [ ! -f "${bench_file_path}" ];then
bench_file_path="$PWD/db_bench_wiredtiger"
fi

if [ ! -f "${bench_file_path}" ];then
echo "Error:${bench_file_path} or $(dirname $PWD )/db_bench_wiredtiger not find!"
exit 1
fi

FILL_PATAMS 

cmd="$bench_file_path $const_params "

if [ -n "$1" ];then    #后台运行
cmd="nohup $bench_file_path $const_params >>out-$nums.out 2>&1 &"
echo $cmd >out-$nums.out
fi

echo $cmd
eval $cmd


