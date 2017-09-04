#!/bin/bash
#contrast
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
if [ $# -eq 1 ];then
  fnameo=`/usr/bin/basename $1`
  if [ ! -f $fnameo ];then
    echo "$fnameo is not existed."
  fi
else
  echo "must input a  file name."
fi

MD5=email_count
PATH1=q_number
PATH2=latest_commit
>test.txt
>testcom.txt
>testjson.json

echo -e "{ \n  \x22children\x22:[">>testjson.json 
rowno=0
rownt=0
md5=00000000000000000000000000000000
path1[0]=xxx
rowno=1
sed -i '$a\ffffffffffffffffffffffffffffffff' 	$fnameo
cat $fnameo|while read line
do
  line=`echo $line`
  if [ " $md5 " == " ${line:0:32} " ];then
    if [ ${line:33:1}x  == "1x" ];then
      path1[$rowno]=${line##*|} 
      rowno=`expr $rowno + 1` 
    elif [ ${line:33:1}x == "2x" ];then
      path2[$rownt]=${line##*|}
      rownt=`expr $rownt + 1`
    fi   
  else
     echo   $md5 --- ${path1[*]} --- ${path2[*]}>>test.txt 

    if [ ${#path1[@]} -ge ${#path2[@]} ];then
      arraylength=${#path1[@]}
    else
      arraylength=${#path2[@]}
    fi
   # arraylength=${#path1[@]}>=${#path2[@]}?${#path1[@]}:${#path2[@]}
   # arraylength2=${#path2[@]}>=${#path1[@]}?${#path1[@]}:${#path2[@]}
   # arraylength=${arraylength1}<${arraylength2}?${arraylength1}:${arraylength2}

# use for loop to read all values and indexes
for (( i=1; i<${arraylength}+1; i++ ));
do
  echo $i ${arraylength} $md5 "|"${path1[$i-1]}"|"${path2[$i-1]}>>testcom.txt
  echo -e  ",{ \n \x22$MD5\x22:\x22${md5}\x22, \n \x22$PATH1\x22:\x22${path1[$i-1]}\x22, \n \x22$PATH2\x22:\x22${path2[$i-1]}\x22 \n } ">>testjson.json
done   

     unset path1
     unset path2
     rowno=0
     rownt=0
     md5=${line:0:32}
     if [ ${line:33:1}x == "1x" ];then
       path1[$rowno]=${line##*|}
       rowno=`expr $rowno + 1`
     elif [ ${line:33:1}x == "2x" ];then
       path2[$rownt]=${line##*|}
       rownt=`expr $rownt + 1`
     fi

     
  fi

done


sed -i '1d' test.txt
sed -i '1d' testcom.txt
sed -i '$d' $fnameo

count=`wc -l testcom.txt`
echo -e "], \n \x22q_number_count\x22:${count%" "*} \n  }">>testjson.json
#>"${fnameo%\.*}"2json.json
sed -i '3,7d' testjson.json
sed -i '3c {' testjson.json
