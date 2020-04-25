#!/bin/bash
filename=$1  # 文件路径
keyword=$2   # 关键词
i=""""/"$keyword"/=""""
numbers=`sed -n -e $i $filename | head -1`   # 命令获取含有关键词的行数
con_str="""$numbers"p""""
content=`sed -n "$con_str" $filename`                            # 获取改行内容
sed -i -e '/'$keyword'/d' $filename  # 删除文件所有的含有关键词的行
con_str=$numbers" i""# "$content   # 组装注释
sed -i """$con_str"""  $filename  # 插入