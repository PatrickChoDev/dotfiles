#compdef ng
###-begin-ng-completions-###
#
# yargs command completion script
#
# Installation: ng completion >> ~/.zshrc
#    or ng completion >> ~/.zprofile on OSX.
#
_ng_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" ng --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _ng_yargs_completions "$@"
else
  compdef _ng_yargs_completions ng
fi
###-end-ng-completions-###

