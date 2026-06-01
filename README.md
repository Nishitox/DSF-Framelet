# DSF Framelet

DSF（Dynamic Storage Frame / 動的ストレージフレーム）は、Minecraft functionにおいて、functionの呼び出しごとに一意なstorage領域を動的に確保し、その参照ID（handle）をmacro引数として受け渡すことで、疑似的なローカル変数環境を実現するための、ミニマムなランタイム機構およびコード設計パターンです。

これにより、1 tick内で完結する「初期化・ループ・完了」の一連の処理を、単一のfunction内に記述しつつ、再帰呼び出しやネストした呼び出しに対しても状態衝突を起こさない、再入可能な実装が可能になります。
この仕組みを利用したfunctionを「**frame関数**」と呼びます。

handleはframeへの参照として機能するため、補助functionはhandleを介して、呼び出し元のframe内データへアクセスできます。これにより、共通処理をfunctionとして外部へ切り出した場合でも、同じframe内データを共有でき、疑似的な参照渡しが可能になります。

これらの機能によって、スコープを持つローカル変数に近い性質をMinecraft上で再現できます。

---

### issue_with_run 関数

`dsf:frame/handle/issue_with_run`は、新しいframe用のhandleを発行し、指定された初期引数にそのhandleを追加して、対象のframe関数を実行するための補助関数です。

通常、frame関数を開始するには、先にhandleを発行し、そのhandleと初期引数を組み合わせてframe関数を呼び出す必要があります。`issue_with_run`関数はこの手続きをまとめて行い、開発者がhandle発行処理を個別に記述せずにframe関数を開始できるようにします。

---

### dsf:frame call ストレージ領域

`dsf:frame call`は、`issue_with_run`が発行したhandleと渡された初期引数を組み立てるために使用するグローバルな一時storage領域です。

`call` は状態保存用ではなく、呼び出し直前の短命なバッファとしてのみ使用します。呼び出し先の関数は、受け取った値を自身のframeにコピーして扱うため、`call`が後続の呼び出しで上書きされても、既存frame の状態には影響しません。


---

### 引数の記述順ルール

引数や処理において、順番が処理結果に影響しない場合、引数の並び順は原則として以下の順序に統一します。

1. `path`: 実行対象の関数（dsfsample:sample）
2. `handle`: 操作対象となるframeを指す番号
3. `route`: frame関数内で通る実行経路（init/root/branch）
4. `elem`: frame関数内で使用する現在の配列要素

例：`/function dsfsample:sample {path:"dsfsample:sample", handle:1, route:"root", elem:""}`

---

### サンプルコード

以下の関数をサンプルとして利用できます。

- `dsfsample:sample`: サンプル用関数。配列を作成し、ループ処理を行います
  - 例：`/function dsf:frame/handle/issue_with_run {path:"dsfsample:sample", arg:{route: "init", elem:0}`

- `dsf:frame/format`: 解放されず残留したdsf:frameストレージを一括解放する関数
  - 例：`/function dsf:frame/handle/issue_with_run {path:"dsf:frame/format", arg:{route: "init", elem:0}}`
