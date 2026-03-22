if status is-interactive
    set -x GOPATH $HOME/go
    set -x PATH $PATH $GOPATH/bin
    set -x fish_user_paths $fish_user_paths $HOME/.cargo/bin
    set -x NVIM_LOG_FILE $HOME/.config/nvim/log/nvim.log

    # peco
    function fish_user_key_bindings
        bind \cr peco_select_history
    end

    # Everforest カラースキーム
    set -l blue             384b55
    set -l light_blue       7fbbb3
    set -l green            a7c080
    set -l dark_green       3c4841
    set -l light_green      a7c080
    set -l red              e67e80
    set -l pink             d699b6
    set -l light_pink       e6c0c0
    set -l orange           e69875
    set -l yellow           e6d6ac
    set -g white            d3c6aa
    set -g black            d3c6aa
    set -g color_dark       333333
    set -g color_discreet   757575
    set -g color_main       $green
    set -g color_main_light $orange
    set -g color_warning    $red
    set -g color_git_main   $blue
    set -g color_git_dirty  $orange

    set -g fish_color_normal            $white
    set -g fish_color_autosuggestion    $color_discreet
    set -g fish_color_cancel            --background=$color_main
    set -g fish_color_command           $color_main_light
    set -g fish_color_comment           $color_discreet
    set -g fish_color_end               $color_main_light
    set -g fish_color_error             $red
    set -g fish_color_escape            $color_discreet
    set -g fish_color_match             --background=$color_main_light
    set -g fish_color_operator          $green
    set -g fish_color_param             $green
    set -g fish_color_search_match      --background=$color_main
    set -g fish_color_selection         --background=$dark_green
    set -g fish_color_quote             $green
    set -g fish_pager_color_progress    $color_main_light
    set -g fish_pager_color_completion  $white
    set -g fish_pager_color_prefix      $color_main_light

    export LSCOLORS=Gxfxcxdxbxegedabagacad
end

# マシン固有設定の読み込み
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
