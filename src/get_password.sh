username=$1
db_file=~/root/script/py/GitHub.Uploader.Pi3.Https.201802210700/res/db/GitHub.Accounts.sqlite3

sql="select Password, MailAddress from Accounts where Username='$username';"
this_dir=`dirname $0`
sql_file=${this_dir}/tmp.sql
echo $sql > $sql_file
select=`sqlite3 $db_file < $sql_file`
rm $sql_file
# "|"→"\n"→改行
#echo -e "takasa02080\nytyaru0@outlook.jp"
#echo -e "a\b\c"
#echo -e "a/b/c"
#echo -e "a\nb\nc"
#echo -e "a\nb\nc"
#echo -e "takasa02080\nytyaru0@outlook.jp"
#echo $select
#echo $select | sed -e "s/|/\\\\n/g"
value=`echo $select | sed -e "s/|/\\\\n/g"`
echo -e "$value"
#echo $select | sed -e "s/|/\\\\n/g" | echo -e
#echo `echo $select | sed -e "s%|%\\\\n%g" | echo -e `
