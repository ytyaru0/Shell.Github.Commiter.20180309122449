function GetPassMail() {
    local username=$1
    local db_file=~/root/script/py/GitHub.Uploader.Pi3.Https.201802210700/res/db/GitHub.Accounts.sqlite3
    local sql="select Password, MailAddress from Accounts where Username='$username';"
    local this_dir=`dirname $0`
    local sql_file=${this_dir}/tmp.sql
    echo $sql > $sql_file
    local select=`sqlite3 $db_file < $sql_file`
    rm $sql_file
    # "|"→"\n"→改行
    local value=`echo $select | sed -e "s/|/\\\\n/g"`
    echo -e "$value"
}
function OverwriteConfig() {
    username=$1
    password=$2
    local before="	url = https://github.com/"
    local after="	url = https://${username}:${password}@github.com/"
    local config=".git/config"
    cp "$config" "$config.BAK"
    sed -e "s%$before%$after%" "$config.BAK" > "$config"
    rm "$config.BAK"
}
function CheckArguments() {
    if [ ! -d "$repo_path" ]; then
        echo "リポジトリパス、ユーザ名、の順に引数を渡してください。リポジトリは存在しません。: $repo_path"
        exit 1
    fi
    if [ ! -n "$username" ]; then
        echo "リポジトリパス、ユーザ名、の順に引数を渡してください。ユーザ名を指定してください。"
        exit 1
    fi
}
function CheckPassword() {
    if [ ! -n "$password" ]; then
        echo "パスワードが見つかりませんでした。DBを確認してください。"
        exit 1
    fi
    if [ ! -n "$mailaddr" ]; then
        echo "メールアドレスが見つかりませんでした。DBを確認してください。"
        exit 1
    fi
}


# $1 対象リポジトリのフルパス
# $2 Githubユーザ名

pre_dir=$0
repo_path=$1
username=$2
#if [ ! -d "$repo_path" ] && exit 1
if [ ! -d "$repo_path" ]; then
    echo "リポジトリパス、ユーザ名、の順に引数を渡してください。リポジトリは存在しません。: $repo_path"
    exit 1
fi
if [ ! -n "$username" ]; then
    echo "リポジトリパス、ユーザ名、の順に引数を渡してください。ユーザ名を指定してください。"
    exit 1
fi
pass_mail=(`GetPassMail $username`)
password=${pass_mail[0]}
mailaddr=${pass_mail[1]}
if [ ! -n "$password" ]; then
    echo "パスワードが見つかりませんでした。DBを確認してください。"
    exit 1
fi
if [ ! -n "$mailaddr" ]; then
    echo "メールアドレスが見つかりませんでした。DBを確認してください。"
    exit 1
fi
git config --local user.name $username
git config --local user.email "$mailaddr"

repo_name=$(basename $repo_path)
cd $repo_path
#repo=$(basename $(cd $(dirname $0); pwd))
echo "$username/$repo_name"
echo "--------------------"
# リモートリポジトリ作成はしていない！
if [ ! -d ".git" ]; then
    echo "リポジトリを作成します。"
    git init
    #json='{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}'it
    json='{"name":"'${repo_name}'"}'
    echo $json | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
    #echo '{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}' | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
#echo '{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}' | nkf -w | curl --cacert "${CURL_PEM}" -u "${GITHUB_USER}:${GITHUB_PASS}" https://api.github.com/user/repos -d @- | nkf -s
    git remote add origin https://${username}:${password}@github.com/${username}/${repo_name}.git
fi
git add -n .
echo "--------------------"
echo 上記でいいならcommit message入力。ダメならEnterキー押下。
read answer
if [ -n "$answer" ]; then
#    pass_mail=`GetPassMail $username`
#    password=${pass_mail[0]}
#    mailaddr=${pass_mail[1]}

    #pass_mail=(`bash ./get_password.sh $username`)
#    git config --local user.name $username
#    git config --local user.email "$mailaddr"
    git add .
    git commit -m "$answer"
    OverwriteConfig "$username" "$password"
    #before="	url = https://github.com/"
    #after="		url = https://${username}:${password}@github.com/"
    #config=".git/config"
    #cp "$config" "$config.BAK"
    #sed -e "s%$before%$after%" "$config.BAK" > "$config"
    #rm ".git/config.BAK"
    git push origin master
fi
cd $(dirname $pre_dir)
