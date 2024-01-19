if status is-interactive
    # Commands to run in interactive sessions can go here
    # クリップボード連携 (For WSL2)
# LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
# export DISPLAY=$LOCAL_IP:0
# . "$HOME/.cargo/env"

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
#
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
# set -x DISPLAY $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

set -x fish_user_paths $fish_user_paths $HOME/.cargo/bin

# ~/.npm-global/bin にパスを通す
set -x fish_user_paths $fish_user_paths $HOME/.npm-global/bin

set -gx LIBVA_DRIVER_NAME iHD
export XDG_SESSION_TYPE=wayland

set -Ux BROWSER /usr/bin/firefox
# alias tmuxg='tmux new-session \; source-file ~/.tmux.session.conf'

# alias di 'docker images [--format] | docker-color-output'
# funcsave di
# alias dps 'docker ps [-a] [--format] | docker-color-output'
# funcsave dps
# alias dcps 'docker compose ps | docker-color-output'
# funcsave dcps

# ---
# peco
# ---
function fish_user_key_bindings
    bind \cr peco_select_history
end

# 使いたい色を登録しておく
set -l blue             384b55
set -l light_blue       7fbbb3
set -l green            a7c080
set -l dark_green       3c4841
set -l light_green      a7co80
set -l red              e67e80
set -l pink             d699b6
set -l light_pink       e6c0c0
set -l orange           e69875
set -l yellow           e6d6ac
# 白と黒は誰が見ても同じなので、グローバルに登録
set -g white            d3c6aa
set -g black            d3c6aa
# 抽象的な名前でグローバルに登録
set -g color_dark       333333
set -g color_discreet   757575
set -g color_main       $green
set -g color_main_light $orange
set -g color_warning    $red
# git color
set -g color_git_main   $blue
set -g color_git_dirty  $orange
# fish color
set -g fish_color_normal            $white                          # デフォルトの色
set -g fish_color_autosuggestion    $color_discreet                 # コマンドの提案の色
set -g fish_color_cancel            --background=$color_main        # 「^c」の色
set -g fish_color_command           $color_main_light               # コマンドの色
set -g fish_color_comment           $color_discreet                 # コメントの色
set -g fish_color_end               $color_main_light               # ; や & などの色
set -g fish_color_error             $red                            # エラーの色
set -g fish_color_escape            $color_discreet                 # \n や \x70 などのエスケープ文字の色
set -g fish_color_match             --background=$color_main_light  # 検索した文字とマッチした時の背景色
set -g fish_color_operator          $green                     # パラメータ演算子の色
set -g fish_color_param             $green                     # 変数
set -g fish_color_search_match      --background=$color_main        # Tab候補の選択などでの背景色
set -g fish_color_selection         --background=$dark_green        # vi、選択モードで選択された部分の背景色
set -g fish_color_quote             $green                     # echo ‘’など
set -g fish_pager_color_progress    $color_main_light               # Tabキーで表示される補完一覧の、左下に表示される文字の色
set -g fish_pager_color_completion  $white                          # Tabキーで表示される補完一覧の文字色
set -g fish_pager_color_prefix      $color_main_light               # Tabキーで表示される補完一覧の、一致した文字の色

export LSCOLORS=Gxfxcxdxbxegedabagacad

end

thefuck --alias | source
