############################# ����
1��ǿת�ַ���Ϊ���ͣ�pid=`echo ${pid}| awk '{print int($0)}'`
2�����㸡��������2λС����awk 'BEGIN{printf "%.2f\n",('1244'/'3'*100)}'
3���������㣺expr 1 + 3945

############################# awk�÷�
1��awk�ָ�ȡ�����У�awk '{print $3}'
2��":"Ϊ�ָ���ȡ��һ�У�awk  -F ':'  '{print $2}'
3��

############################# sed�÷�
2��ȡ���صĵڶ��У�sed -n '2p'

############################# grep�÷�
1��grep -w "abc23"                       ��ȷƥ��
2��grep -v "abc"                         �ų�
3��grep -Ev '^$|#' /etc/ssh/sshd_config  �ų��ļ���#�Ϳ���

############################# xargs�÷�
1������ɱ���̣�ps -aux | grep httpd | grep -v grep | cut -c 7-15 | xargs kill -9 
rpm -qa | grep docker | xargs -I rpm -e {} --nodeps
############################# cut�÷�

sed  ���������ı���������
sed����ɾ���ļ��к��С�abc����һ��
#  sed -i -e '/abc/d' /etc/exports
sed�����ȡ���С�abc��������
#  sed -n -e '/abc/='  shit.txt
sed������롰rrr������2��ǰ��
#  sed '2 irrr' -i shit.txt
sed������롰PASS_WARN_AGE 26����/etc/login.defs��line_number�к���
#  sed -i "$line_number"i"PASS_WARN_AGE 26" /etc/login.defs
�鿴���һ�е�����
#  sed -n '$p'



3����ó���ĳ�ַ������ļ��ڼ��У�#   grep -rn 'abc'  a.txt

4��sed�ڵ�3�в����ļ��ַ�����abc����# sed -i "3iabc"  a.txt

5��sedɾ���ļ����еĺ����ַ�����abc�����У� #  sed  -i  '/abc/d'  a.txt

6����ȡ������ߵ��ַ�����#   ${������%����*}

7����ȡ�����ұߵ��ַ�����#   ${������#*����}

8����ð��Ϊ�ָ���cat /etc/passwd | awk -F "[:]"  '{print $3}'

grep -w ��ȷƥ��
grep -v �ų�
grep�����ų�ע���кͿ��У�grep -Ev '^$|#' /etc/ssh/sshd_config



