#########---------------LORENS ZSH

z(){
    n ~/.lorens_bash/lorens.zsh
}
bn(){
    if [ -z $1  ]; then
         echo choose file to run with bun !! 
    else
        c && bun run $1 
    fi
}
cdl(){
    if [ -z $1  ]; then
        exa --tree --level=1 --group-directories-first --icons 
    else
        cd $1 && exa --tree --level=1 --group-directories-first --icons 
    fi
}
#like cd() function but show hidden foldres and files
cdla(){
    if [ -z $1  ]; then
        exa --tree --level=1 --group-directories-first --icons -a
    else
        cd $1 && exa --tree --level=1 --group-directories-first --icons -a
    fi
}
re(){
    source ~/.zshrc

    echo reloded
    
     
}
c(){
    clear
}

#--------|[ Explorer ]|--------#
e(){
    
    if [ -z $1  ]; then
        nautilus .
    else
        nautilus $1
    fi
}

#--------|[ n() function ]|--------#
n(){
    
    gnome-text-editor   $1
}

#--------|[ Usful Commands ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.

function useful_commands() {
  commands_file="/home/lorens/Files/usefull_commands.txt"
  header="CommandsList"

  fzf_cool=(
    --border-label="$header"
    --prompt="down Arrow:down, upArrow:up, ESC: dismiss, Enter: print_command"
    --reverse
    --border=sharp
    --pointer="➜"
    --disabled
    --no-info
    --height 40%
    --no-separator
    --color=dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:#cb4b16,prompt:#dd4814:bold,pointer:#dd4814:bold
  )

  if [[ $1 = "file" ]]; then
    echo "Commands List file path is: $commands_file" && gnome-text-editor -i $commands_file
  elif [[ $1 = "add" ]]; then
    echo "Commands List file path is: $commands_file" && gnome-text-editor $commands_file
  elif [[ -z $1 ]]; then
    selected_command=$(cat $commands_file | grep -v '^$' | grep -v '^#'| sed -e 's/^[ \t]*//' | fzf $fzf_cool | awk '!/^[\*]/')
     print -z $selected_command
  fi
}

alias uc="useful_commands"

#--------|[ neat_explorer ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.
#Note cd() invoked in neat_explorer()
cd() {
  [[ $# -eq 0 ]] && return
  builtin cd "$@"
}

# n() notepad

function neat_explorer() {
  # --border-label=lorens is unnecessary with fzf `header` option
  info_inline_separator=']'

  fzf_cool=(
    --reverse

    --border=sharp
    --height 40%
    --info=inline:$info_inline_separator
    --separator=""
    --prompt="[ "  
    --pointer="→"
    --color=fg:#839496,bg+:#242424,spinner:#719e07,hl+:#5fff87,disabled:#ce392c
    --color=header:#586e75,info:#cb4b16,pointer:#5fff87
    --color=marker:#719e07,fg+:#839496,prompt:#5fff87,hl:#719e07
  )

  cd "$1"

  if [[ -z "$1" ]]; then
    selection="$(exa --tree --level=1 --group-directories-first --icons -a | fzf --header="$(pwd)" "$fzf_cool[@]" )"

    if [[ "${#selection}" -gt 6 ]]; then
      new_selection="${selection:6}"

      if [[ -d "$new_selection" ]]; then
        cd "$new_selection" && neat_explorer
      elif [[ -f "$new_selection" ]]; then
        n "$new_selection"
      fi
    elif [[ "${#selection}" -eq 3 ]]; then
      new_selection="${selection:1}"
      cd .. && neat_explorer
    else
      echo ""
    fi
  fi
}

alias cd="neat_explorer"




