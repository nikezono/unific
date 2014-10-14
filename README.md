unific  ![Travis](https://travis-ci.org/nikezono/unific.png)[![Test Coverage](https://codeclimate.com/github/nikezono/unific/badges/coverage.svg)](https://codeclimate.com/github/nikezono/unific)[![Code Climate](https://codeclimate.com/github/nikezono/unific/badges/gpa.svg)](https://codeclimate.com/github/nikezono/unific)
---

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


## Unific - Recursive & Anonymous RSS Reader

http://www.unific.net

* unificは「RSSフィードを生成できる」RSSリーダです
  * Webアプリケーションとして実装されています
    * フィードの購読/検索が行えます
  * 購読している各フィードの新着記事をマージしたRSSを生成出来ます
    * 他のRSSリーダを購読することができます
  * 子や孫のリーダの購読リストの変更を、親も受け取ります
    * ex: @nikezono の読んでいるニュース記事(/nikezono)を組織で購読する(/masuilab)
    * ex: `/jpop` でJ-POPについてのリーダーを管理し、`/music`が`/jpop`や`/rock`を購読する
* アカウントはありません
  * `http://www.unific.net/リーダーの名前`でリーダを生成します
  * 全てのユーザに編集権限があります


Contributing
------------
1. Fork it
2. Create (Enhancement/Debug/Develop) Issue (ex:`#3-some-error-occurred-in-some-environment`)
3. Create your feature branch (`git checkout -b 3_something_bugfix`)
4. Commit your changes (`git commit -am '#3 fixed'`)
5. Push to the branch (`git push origin #3-some-error-occurred-in-some-environment`)
6. Create new Pull Request
