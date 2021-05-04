if [[ ! -f "../open-task.sh" ]] || [[ ! -f "../close-task.sh" ]]
then
    echo "open-task.sh and close-task.sh do not exist in the parent folder"
    exit 1
fi

printf "Clearing old git aliases if exists... "
git config --global --unset alias.open-task
git config --global --unset alias.close-task
echo "DONE"

read -p "Folder's absolute path for git aliases (If left blank \$HOME/.git_alias): " install_dir
if [[ -z "$install_dir" ]] 
then
    install_dir="$HOME/.git_alias"
fi

printf "Copying aliases in $install_dir ... "
mkdir -p "$install_dir"
cp "../open-task.sh" "$install_dir"
cp "../close-task.sh" "$install_dir"
echo "DONE"

printf "Setting global aliases... "
git config --global alias.open-task "! $install_dir/open-task.sh"
git config --global alias.close-task "! $install_dir/close-task.sh"
echo "DONE"

echo "Installation complete"