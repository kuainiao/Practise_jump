
# 此处为指标判断阈值
HEAP_FREE_PERCENT_COMPARE=0     # 获取Heap区空闲内存百分比成功数值，大于60%为异常
NO_HEAP_FREE_PERCENT_COMPARE=0  # 获取非Heap区空闲内存百分比成功数值，大于60%为异常

SERVER_PID=$(netstat -ntlp | awk '$4 ~ /'":${port}$"'/{print $NF}'|awk -F"/" '{print $1}' |uniq)
SERVER_TYPE=$(netstat -ntlp | awk '$4 ~ /'":${port}$"'/{print $NF}'|awk -F"/" '{print $2}' |uniq)
if [ -n "${SERVER_PID}" -a "${SERVER_TYPE}" == "java" ]; then
    JVM_DATA=$(jstat -gc ${SERVER_PID} | awk '{for(i=1;i<=NF;i++){if($i=="S0C" && NR==1){S0C=i} else if($i=="S1C" && NR==1){S1C=i} else if($i=="EC" && NR==1){EC=i} else if($i=="OC" && NR==1){OC=i} else if($i=="S0U" && NR==1){S0U=i} else if($i=="S1U" && NR==1){S1U=i} else if($i=="EU" && NR==1){EU=i} else if($i=="OU" && NR==1){OU=i} else if($i=="PC" && NR==1){PC=i} else if($i=="MC" && NR==1){PC=i} else if($i=="PU" && NR==1){PU=i} else if($i=="MU" && NR==1){PU=i}}}END{printf "%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n",($S0C+$S1C+$EC+$OC)/1024,(($S0C+$S1C+$EC+$OC)/1024)-(($S0U+$S1U+$EU+$OU)/1024),((($S0C+$S1C+$EC+$OC)-($S0U+$S1U+$EU+$OU))/($S0C+$S1C+$EC+$OC))*100,$PC/1024,($PC-$PU)/1024,(($PC-$PU)/$PC)*100}')
    if [ $? -ne 0 ]; then
        message="JAVA_HOME变量异常，请填写SET_JAVA_HOME参数，指定正确的jdk路径"
		echo -ne  "["
        echo -ne  "{\"message\":{\"value\":$message,\"unit\":\"\",\"status\":1}},"
        echo -ne  "]"
    else
        HEAP_TOTAL=$(echo ${JVM_DATA} | awk '{print $1}')        # 获取Heap区内存总数成功数值
        HEAP_FREE=$(echo ${JVM_DATA} | awk '{print $2}') # 获取Heap区空闲内存成功数值
        HEAP_FREE_PERCENT=$(echo ${JVM_DATA} | awk '{print $3}') # 获取Heap区空闲内存百分比成功数值
        NO_HEAP_TOTAL=$(echo ${JVM_DATA} | awk '{print $4}') # 获取非Heap区内存总数成功数值
        NO_HEAP_FREE=$(echo ${JVM_DATA} | awk '{print $5}') # 获取非Heap区空闲内存成功数值
        NO_HEAP_FREE_PERCENT=$(echo ${JVM_DATA} | awk '{print $6}') # 获取非Heap区空闲内存百分比成功数值
		
	    HEAP_FREE_PERCENT=`echo ${HEAP_FREE_PERCENT}| awk '{print int($0)}'`
		if [ $HEAP_FREE_PERCENT -gt $HEAP_FREE_PERCENT_COMPARE ];then
            HEAP_FREE_PERCENT_STATUS=1
        else
            HEAP_FREE_PERCENT_STATUS=0
        fi
        NO_HEAP_FREE_PERCENT=`echo ${NO_HEAP_FREE_PERCENT}| awk '{print int($0)}'`
        if [ $NO_HEAP_FREE_PERCENT -gt $NO_HEAP_FREE_PERCENT_COMPARE ];then
            NO_HEAP_FREE_PERCENT_STATUS=1
        else
            NO_HEAP_FREE_PERCENT_STATUS=0
        fi
		echo -ne  "["
        echo -ne  "{\"HEAP_TOTAL\":{\"value\":$HEAP_TOTAL,\"unit\":\"M\",\"status\":0}},"
		echo -ne  "{\"HEAP_FREE\":{\"value\":$HEAP_FREE,\"unit\":\"M\",\"status\":0}},"
		echo -ne  "{\"HEAP_FREE_PERCENT\":{\"value\":$HEAP_FREE_PERCENT,\"unit\":\"%\",\"status\":$HEAP_FREE_PERCENT_STATUS}},"
        echo -ne  "{\"NO_HEAP_TOTAL\":{\"value\":$NO_HEAP_TOTAL,\"unit\":\"M\",\"status\":0}},"
        echo -ne  "{\"NO_HEAP_FREE\":{\"value\":$NO_HEAP_FREE,\"unit\":\"M\",\"status\":0}},"
        echo -ne  "{\"NO_HEAP_FREE_PERCENT\":{\"value\":$NO_HEAP_FREE_PERCENT,\"unit\":\"%\",\"status\":$NO_HEAP_FREE_PERCENT_STATUS}}",
		echo -ne  "{"\"MaxPermSize"\":{"\"value"\":"\"$MaxPermSize"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"CICompilerCount"\":{"\"value"\":"\"$CICompilerCount"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"ip"\":{"\"value"\":"\"$ip"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"headless"\":{"\"value"\":"\"$headless"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"policy"\":{"\"value"\":"\"$policy"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"auth"\":{"\"value"\":"\"$auth"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"startTransient"\":{"\"value"\":"\"$startTransient"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"NewRatio"\":{"\"value"\":"\"$NewRatio"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"disableConfigSave"\":{"\"value"\":"\"$disableConfigSave"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}",
        echo -ne  "{"\"LoggerImpl"\":{"\"value"\":"\"$LoggerImpl"\","\"unit"\":"\""\","\"status"\":"\"0"\"}}"
        echo -ne  "]"
    fi
fi
