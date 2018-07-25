#!/bin/bash
# This is a script to copy files from one host to a group of hosts

# There are three variables accepted via commandline
# $1 = first parameter (/source_path/source_filename)
# $2 = second parameter (/target_directory/)
# $3 = third paramter (file that contains list of hosts)

SOURCEFILE=/root/aaa/file1
SOURCEFILE1=/root/aaa/file2
model=/root/aaa/file3
TARGETDIR=/root/
nohup=/root/aaa/nohup

while read ipaddress;
do
echo "Check network now......"
ping -q -c 5 $ipaddress >/dev/null
if [ "$?" = 0 ]
then
  echo "Host $ipaddress found,start scp!"
     sshpass -p '1234' scp -P2222 $SOURCEFILE1 root@${ipaddress}:/root/file1
     sshpass -p '1234' scp -P2222  $SOURCEFILE root@${ipaddress}:/root/file2
     sshpass -p '1234' scp -P2222 $model root@${ipaddress}:/root/file3
	 sshpass -p '1234' scp -P2222 $nohup root@${ipaddress}:/bin/nohup
	echo "$ipaddress scp success!!!!"
     #sshpass -p '1234' ssh -p2222 root@${ipaddress} 'bash -s < /root/model.sh'
	  sshpass -p '1234' ssh -p2222 -oStrictHostKeyChecking=no root@${ipaddress} "chmod 777 /bin/nohup"
	 sshpass -p '1234' ssh -p2222 -oStrictHostKeyChecking=no root@${ipaddress} "/bin/nohup sh /root/model.sh > /dev/null 2>&1 &"
else
  echo "Host not found,pls check your network!!!"
  exit 1
fi
     
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "$ipaddress upgrade success!!" >> /root/aaa/success.txt
else
  echo "$ipaddress upgrade fail!!!" >> /root/aaa/fail.txt
fi
done < /root/aaa/ip.txt
