# 学校アンケートシステム Cloud Edition

## 含まれるファイル
- `index.html`: 学生用回答画面・先生用管理画面
- `schema.sql`: SupabaseテーブルとRow Level Security設定

## セットアップ
1. https://supabase.com/ でアカウントを作成し、無料プロジェクトを作成。
2. Supabase Dashboard > SQL Editorで `schema.sql` 全体を実行。
3. Project URLとPublishable key (`sb_publishable_...`) を取得。
4. **全学生の端末で接続できるようにする重要な設定：** `index.html` をテキストエディタで開き、冒頭付近の `PUBLIC_SUPABASE_URL` と `PUBLIC_SUPABASE_KEY` にProject URLとPublishable keyを記入して保存。これにより同じ公開サイトを訪れる全員が同じSupabaseプロジェクトへ接続します。Publishable keyのみを使用してください。
   - 接続設定画面に入力して保存する方法は、そのブラウザだけに保存されます。公開サイトでは必ず上記の定数にも設定してください。
5. 先生用画面からメールアドレスと強いパスワードで先生アカウントを登録。必要なら確認メールを承認。
6. アンケートを作成し、質問を編集して公開。
7. 「学生URL」ボタンでURLをコピーし、学生へ配布。

## GitHub Pages公開
1. https://github.com/ でアカウントを作成。
2. Public repository（例: `school-survey`）を作成。
3. `index.html` をリポジトリのルートにアップロード。
4. Settings > Pages > Deploy from a branch > `main` / `/(root)` を保存。
5. 表示されたGitHub Pages URLを開き、接続設定を行う。

## セキュリティ上の重要事項
- Publishable keyは公開フロントエンドで使用するキーです。Secret key / service_role keyは絶対にブラウザに置かないでください。
- RLSを有効化し、学生は公開中アンケートの読み取りと回答送信だけ、先生は自分のアンケートとその回答の閲覧だけができるようにしています。
- 回答テーブルには回答者名・メールアドレス・回答者IDを保存しません。ただしサービス側の技術ログ等まで完全匿名になるわけではありません。
- 公開URLを知る人は誰でも回答できます。転送に注意し、必要ならCAPTCHAやレート制限を追加してください。
- このスターターは複数先生の個別所有に対応します。先生アカウント登録を一般公開したくない場合、運用前にSupabase Authの新規登録を無効化し、管理者が先生アカウントを作成する方式へ変更してください。
- Supabase Freeには利用上限があり、非アクティブ時にプロジェクトが一時停止される場合があります。学校の正式運用前にバックアップ、保存期間、学校の個人情報保護方針を確認してください。
- 公開前に、複数端末で回答テストと権限テストを行ってください。

## 公式資料
Supabase RLS: https://supabase.com/docs/guides/database/postgres/row-level-security
Supabase API keys: https://supabase.com/docs/guides/getting-started/api-keys
GitHub Pages: https://docs.github.com/en/pages
