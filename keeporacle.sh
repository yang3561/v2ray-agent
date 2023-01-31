#!/bin/bash
echo "欢迎使用甲骨文保活脚本"
echo "1.AMD"
echo "2.ARM"
read -p "请选择" choice

if (($choice == 1)); then
mkdir -p ~/keep_oracle
cat <<EOF >~/keep_oracle/crontab.sh
#!/bin/bash

for (( i = 0; i < 5; i+=1)); do
    wget --limit-rate=10m http://cachefly.cachefly.net/100mb.test -O /tmp/100mb.test
    sleep 10
    sudo apt update
done

exit 0
EOF
chmod +x ~/keep_oracle/crontab.sh
crontab -l > conf
echo "* * * * * ~/keep_oracle/crontab.sh" >> conf
crontab conf
rm -f conf
crontab -l
echo "脚本结束，如果新增了一条crontab即为运行成功"

elif (($choice == 2)); then
mkdir -p ~/keep_oracle
cat <<EOF >~/keep_oracle/crontab.sh
#!/bin/bash

for (( i = 0; i < 5; i+=1)); do
    wget --limit-rate=10m http://cachefly.cachefly.net/100mb.test -O /tmp/100mb.test
    sleep 10
    dd if=/dev/zero of=/tmp/test bs=1M count=128
done

exit 0
EOF
dd if=/dev/zero of=/dev/shm/keep_oracle bs=1K count=`cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g'|sed 's/ kB//'|sed 's/.$//g'`
chmod +x ~/keep_oracle/crontab.sh
crontab -l > conf
echo "* * * * * ~/keep_oracle/crontab.sh" >> conf
echo "@reboot dd if=/dev/zero of=/dev/shm/keep_oracle bs=1K count=`cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |sed 's/^[ \t]*//g'|sed 's/ kB//'|sed 's/.$//g'`" >> conf
crontab conf
rm -f conf
crontab -l
echo "脚本结束，如果新增了两条crontab即为运行成功"
fi