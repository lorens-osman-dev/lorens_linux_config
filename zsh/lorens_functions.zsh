#########---------------LORENS ZSH

z(){
    n /home/lorens/lorens_linux_config/zsh/.zshrc
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
#like cdl() function but show hidden folders and files
cdla(){
    if [ -z $1  ]; then
        exa --tree --level=1 --group-directories-first --icons -a
    else
        cd $1 && exa --tree --level=1 --group-directories-first --icons -a
    fi
}
re(){
    source ~/.zshrc

    echo "\033[32mReloaded ✓✓ \033[0m"
    
     
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
    
    if [ -z $1  ]; then
        echo "There is no file to open"
    else
        gnome-text-editor   $1
    fi
}

#--------|[ Useful Commands ]|--------#
function useful_commands() {
    # You need to export $commands_file so it can be accessible inside the preview shell
    # Or use the full path instead of the variable
    declare -x commands_file="${HOME}/lorens_linux_config/zsh/usefull_commands.txt"
    header="CommandsList"
    fzf_cool=(
        --reverse
        --pointer="➜"
        --info=inline-right 
        --height 40%
        --no-separator
        --preview-window=down,20%,wrap
        --color='dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:#cb4b16,prompt:#dd4814:bold,pointer:#dd4814:bold'
    )

    case "$1" in
        file) echo "Commands List file path is: $commands_file" && gnome-text-editor -i "$commands_file" ;;
        add)  echo "Commands List file path is: $commands_file" && gnome-text-editor "$commands_file" ;;
        *)
            selected_command=$(grep -v '^$' "$commands_file"| grep -v '^#'| sed -e 's/^[ \t]*//' | grep -v '^\*\*'  | fzf "${fzf_cool[@]}" \
                --preview fzf --preview 'echo -e "\033[32m$(grep -xF -B1 {} "${commands_file}" | sed "s/^**//"| head -1)\033[0m"')
		# the original --preview is :--preview 'grep -xF -B1 {} "${commands_file}" | sed "s/^**//"| head -1' )
            print -z $selected_command
        ;;
    esac
}
alias uc="useful_commands"


#--------|[ neat_explorer ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.
#Note cd() invoked in neat_explorer()
#Note before cd() was not function word , we added it to test,  
#when we add it the reload works perfectly but neat_explorer() doesn't work after reload , if we remove it reload doesn't works but
# neat_explorer() works
function cd() {
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

#--------|[ save MAN pages to file.txt ]|--------#
manp() {
  if [ -z "$1" ]; then

    echo "\033[32mThe \033[1mmanp\033[0m \033[32mfunction is a function that saves command's manual pages to a Documents directory.\033[0m"

  else
    declare -x TXT_FILE_PATH="${HOME}/Documents/${1}.txt"
    echo "\033[32mThe \033[1m${1}\033[0m \033[32mcommand's manual pages created in : ${TXT_FILE_PATH}\033[0m"
    man "$1" > "$TXT_FILE_PATH"
  fi
}
