function dotfiles
  echo "[i] Updateing dotfiles"
  cd ~/.dotfiles
  git pull
  if test (count $argv) -gt 0
    for option in $argv
      switch "$option"
        case -w --work
          echo "[i] Running ansible in WORK mode"
          ansible-playbook -i $HOME/.dotfiles/hosts $HOME/.dotfiles/playbook.yml --ask-become-pass --extra-vars "work=True"
      end
    end
  else
    echo "[i] Running ansible"
    ansible-playbook -i $HOME/.dotfiles/hosts $HOME/.dotfiles/playbook.yml --ask-become-pass
  end
end
