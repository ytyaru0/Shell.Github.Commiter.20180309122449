# このソフトウェアについて

簡易アップローダ。

以下のアップローダで作成されたDBからパスワードとメアドを取得する。.shにハードコーディングせずに済む。

* https://github.com/ytyaru0/GitHub.Uploader.Pi3.Https.201802210700
* https://github.com/ytyaru0/GitHub.Uploader.Pi3.Https.201803020700

要`sqlite3`コマンド。

# 使い方

```sh
$ bash /.../push.sh
```

# 例

* [時刻あわせ](src/settime.sh)
* [pyenv 初期化](src/pyenv.sh)
* [python venv 有効化](src/py_venv.sh)
* [作業用ディレクトリ作成](src/mkdir_work.sh)

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 8.0 (jessie)
        * bash 4.3.30

# ライセンス

このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

利用ライブラリは以下。

Library|License|Copyright
-------|-------|---------
[assert.sh](https://github.com/lehmannro/assert.sh)|[LGPL-3.0](https://github.com/lehmannro/assert.sh/blob/master/COPYING.LESSER)|[Copyright (C) 2007 Free Software Foundation, Inc. http://fsf.org/](https://github.com/lehmannro/assert.sh/blob/master/COPYING)

