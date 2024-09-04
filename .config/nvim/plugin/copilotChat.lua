local status, copilotChat = pcall(require, 'CopilotChat')
if not status then
  return
end

local select = require('CopilotChat.select')
copilotChat.setup {
  debug = true, -- Enable debugging
  model = 'gpt-4', -- モデル名の確認
  -- プロンプトの設定
  prompts = {
    Explain = {
      prompt = "/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて書いてください。",
      mapping = '<leader>ce',
      description = "コードの説明をお願いする",
    },
    Review = {
      prompt = "/COPILOT_REVIEW カーソル上のコードをレビューしてください。コードの問題点や改善点を指摘してください。",
      mapping = '<leader>cr',
      description = "コードのレビューをお願いする",
    },
    Tests = {
      prompt = "/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。",
      mapping = '<leader>ct',
      description = "テストコードの作成をお願いする",
    },
    Fix = {
      prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。",
      mapping = '<leader>cf',
      description = "コードの修正をお願いする",
    },
    Optimize = {
      prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
      mapping = '<leader>co',
      description = "コードの最適化をお願いする",
    },
    Docs = {
      prompt = "/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）",
      mapping = '<leader>cd',
      description = "ドキュメントの作成をお願いする",
    },
    FixDiagnostic = {
      prompt = "ファイル内の次のような診断上の問題を解決してください：",
      selection = select.diagnostics,
      mapping = '<leader>cx',
      description = "診断上の問題の解決をお願いする",
    },
    Commit = {
      prompt =
      'commitize の規則に従って、変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
      mapping = '<leader>cc',
      description = "コミットメッセージの作成をお願いする",
      selection = require('CopilotChat.select').gitdiff,
    },
    CommitStaged = {
      prompt =
      'commitize の規則に従って、ステージ済みの変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
      mapping = '<leader>cs',
      description = "ステージ済みのコミットメッセージの作成をお願いする",
      selection = function(source)
          return require('CopilotChat.select').gitdiff(source, true)
      end,
    },
  }
}

