#! /bin/sh

db_path="/home/hhs/WT_bench"

key_size="16" #默认，暂时不能修改
value_size="16"

# benchmarks="fillrandom,stats,readrandom,stats,rangerandom,stats,updaterandom,stats,deleterandom" 
benchmarks="fillrandom,readrandom,rangerandom,updaterandom,deleterandom" 

#num="1000000"  #
#num="10000000"  #1千万，0.32G
num="100000000"  #1亿，3.2G
#num="1000000000"  #10亿，32G
#num="10000000000"  #100亿，320G

cache_size="`expr $num \* \( $key_size + $value_size \) \* 1 / 10 `"

reads="10000000"  #读取固定1千万条
deletes="10000000" #删除1千万条
updates="10000000" #修改1千万条

seek_nexts="20"

threads="4"
use_lsm="0"
#bloom_bits="10"

batch_size="100"  #没作用，没有发现有batch操作

direct_io="0" # 1 = [data]; 2 = [data,log] (有问题)

stats_type="0"

log_enable="0"
# log_file_max="`expr 64 \* 1024 \* 1024 `"

transaction_sync_enable="1"

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

    if [ -n "$cache_size" ];then
        const_params=$const_params"--cache_size=$cache_size "
    fi
    
    if [ -n "$num" ];then
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

    if [ -n "$log_enable" ];then
        const_params=$const_params"--log_enable=$log_enable "
    fi

    if [ -n "$log_file_max" ];then
        const_params=$const_params"--log_file_max=$log_file_max "
    fi

    if [ -n "$transaction_sync_enable" ];then
        const_params=$const_params"--transaction_sync_enable=$transaction_sync_enable "
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


