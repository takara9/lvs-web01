lvs-web01 Cookbook
==============
LVSのリアルサーバー側の設定のクックブックです。 DSR方式でロードバランスする場合、リアルサーバー側には、仮想サーバー宛てのパケットを受けること、FIN_WAITのタイムアウト時間を短くするなどのカーネル関係の設定が必要で、ファイアウォール設定も適していなければなりません。これらの設定を自動化するのが、このクックブックです。


このクックブックには、Apache HTTPd Server や NGINX などのパッケージの導入設定は含まれていないので、他のクックブックと組み合わせるか、手作業で導入する必要があります。

# 設定内容

このクックブックは下記４つの設定をおこないます。

1. OSファイアウォール設定
2. パッケージ追加
3. VIP用のループバック・インタフェースの追加
4. カーネルパラメータの設定


要件
------------

### LVSサーバーの設定
このURL (https://github.com/takara9/lvs01) にあるクックブックに対応するものです。

### 確認済オペレーティング・システム
- Ubuntu Linux 14.04 LTS Trusty Tahr - Minimal Install (64 bit) 
- CentOS 6.x - Minimal Install (64 bit)
- CentOS 7.x - Minimal Install (64 bit)

### プロビジョニングスクリプト
SoftLayerのサーバー起動時に設定するプロビジョニング・スクリプトで次のURLを設定する事を前提にしてます。
- Ubuntu https://raw.githubusercontent.com/takara9/ProvisioningScript/master/ubuntu_basic_config
- CentOS6 https://raw.githubusercontent.com/takara9/ProvisioningScript/master/centos_basic_config
- CentOS7 https://raw.githubusercontent.com/takara9/ProvisioningScript/master/centos7_basic_config


アトリビュート
----------
#### lvs-web01::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>

  <tr> 
    <td>["virtual_ipaddress1"]</td>
    <td>IP address</td>
    <td>代表となるIP (VIP)</td>
    <td>NULL (必須)</td>
  </tr>

</table>




使い方
------------

```
# curl -L https://www.opscode.com/chef/install.sh | bash
# knife cookbook create dummy -o /var/chef/cookbooks
# cd /var/chef/cookbooks
# git clone https://github.com/takara9/lvs-web01
```


License and Authors
-------------------

Authors: Maho Takara

License: see LICENCE file
