# DSF Framelet

DSF（Dynamic Storage Frame / 動的ストレージフレーム）は、Minecraft functionにおいて、functionの呼び出しごとに一意なstorage領域を動的に確保し、その参照ID（handle）をmacro引数として受け渡すことで、疑似的なローカル変数環境を実現するための、ミニマムなランタイム機構およびコード設計パターンです。

これにより、schedule等によってtickをまたぐことなく、1 tick内で完結する「初期化・ループ・完了」の一連の処理を、単一のfunction内に記述しつつ、再帰呼び出しやネストした呼び出しに対しても状態衝突を起こさない、再入可能な実装が可能になります。
この仕組みを利用したfunctionを「**frame関数**」と呼びます。

handleはframeへの参照として機能するため、補助functionはhandleを介して、呼び出し元のframe内データへアクセスできます。これにより、共通処理をfunctionとして外部へ切り出した場合でも、同じframe内データを共有でき、疑似的な参照渡しが可能になります。

この仕組みによって、Minecraftのグローバルなstorage上で明示的なライフサイクルを持つ「疑似的なローカル状態管理」を扱えるようになります。

---

### 対象バージョン

* `Minecraft 26.1.2`を前提に作成しています。それ以前のバージョンでの動作確認は行っておりませんので、正常に動作しない可能性があります。

### 導入方法

1. [DSF-Framelet-main.zip](https://github.com/Nishitox/DSF-Framelet/archive/refs/heads/main.zip)をダウンロードします
2. ダウンロードしたzipファイルの中身を`<使用するワールド>/datapacks/DSF-Framelet-main/pack.mcmeta`となるように配置してください
3. 使用するワールド上で`/function dsf:init`を実行してください

---

### サンプルコード

以下の関数をサンプルとして利用できます。

- `dsfsample:sample`: サンプル用関数。配列を作成し、ループ処理を行います  
  例：`/function dsf:frame/handle/issue_with_run {path:"dsfsample:sample", arg:{route: "init", elem:0}}`

- `dsf:frame/format`: 解放されず残留したdsf:frameストレージを一括解放する関数  
  例：`/function dsf:frame/handle/issue_with_run {path:"dsf:frame/format", arg:{route: "init", elem:0}}`

### frame関数の作成方法

`dsfsample:template`をコピーして作成します。

- `任意処理`とコメントのあるコマンドの箇所に、処理したい内容を記述します。
- `固定処理`とコメントのあるコマンドは制御に必要なコマンドです。削除や実行順の変更はできません。

---

### 変数の構成

各frameは主に以下の2領域を持ちます
1. `arg(argument)`: frame関数を呼び出す際に渡す実引数として利用される領域です。`path`,`handle`,`route`,`elem`などの引数が入ります。

2. `prm(parameter)`: 渡された引数を格納する仮引数として利用される領域です。そのほかにlist等のframe関数内で利用する作業用のデータは原則としてprmに格納します。

### 主要な引数の説明及び記述順のルール

引数や処理において、順番が処理結果に影響しない場合、引数の並び順は原則として以下の順序に統一します。

1. `path`: 実行対象の関数（dsfsample:sample）
2. `handle`: 操作対象となるframeを指す番号
3. `route`: frame関数内で通る実行経路（init/root/branch）
4. `elem`: frame関数内で使用する現在の配列要素

例：`/function dsfsample:sample {path:"dsfsample:sample", handle:1, route:"root", elem:""}`

---

### format 関数

`dsf:frame/format`は、`dsf:handle cache`を元に、使用された痕跡のあるframe領域を強制的に削除する関数です。原則としてframe関数は正常終了時に対象のframeを解放する設計になっていますが、異常終了などでframeが正常に解放されずに残留した場合にすべてのframeを一括で削除するための機能です。**使用中のframeであっても強制的に解放されるため、デバッグや初期化での使用を想定しています。**

---

### issue_with_run 関数

`dsf:frame/handle/issue_with_run`は、新しいframe用のhandleを発行し、指定された初期引数にそのhandleを追加して、対象のframe関数を実行するための補助関数です。

通常、frame関数を開始するには、先にhandleを発行し、そのhandleと初期引数を組み合わせてframe関数を呼び出す必要があります。`issue_with_run`関数はこの手続きをまとめて行い、開発者がhandle発行処理を個別に記述せずにframe関数を開始できるようにします。

---

### dsf:frame call ストレージ領域

`dsf:frame call`は、`issue_with_run`が発行したhandleと渡された初期引数を組み立てるために使用するグローバルな一時storage領域です。

`call` は状態保存用ではなく、呼び出し直前の短命なバッファとしてのみ使用します。呼び出し先の関数は、受け取った値を自身のframeにコピーして扱うため、`call`が後続の呼び出しで上書きされても、既存frame の状態には影響しません。
