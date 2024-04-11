#!/usr/bin/env bash

# Prompt the user to confirm adding all files
echo "Are you sure you want to add all files in the current directory? (yes/no) [yes]:"
read confirmation

# Set default value if no input is given
confirmation=${confirmation:-yes}

# Convert the input to lower case for easier comparison
confirmation=${confirmation,,}

# Check if the user confirmed using multiple possible affirmative answers or default
if [[ $confirmation == "yes" || $confirmation == "y" ]]; then
  # Perform the git add
  git add *
  echo "All files added."
else
  echo "Add cancelled by user."
  exit 1
fi

# Loop until a valid commit message is entered
while true; do
    echo "Enter your git commit message:"
    read commit_message

    # Check if the commit message is empty
    if [[ -z "$commit_message" ]]; then
      echo "Commit message cannot be empty. Please enter a valid commit message."
    else
      break
    fi
done

# Perform the git commit
git commit -m "$commit_message"

# Check if the git commit was successful
if [ $? -eq 0 ]; then
  echo "Commit was successful."
else
  echo "Commit failed."
fi

# Perform the git push to the remote repository
echo "Pushing to GitHub..."
git push github main

# Check if the git push was successful
if [ $? -eq 0 ]; then
  echo "Push to GitHub was successful."
else
  echo "Push failed. Check your remote repository and branch name and ensure your network settings are correct."
  exit 1
fi


# Switch configurations using home-manager
echo "Switching home-manager configurations..."
home-manager switch --flake .

# Check if home-manager switch was successful
if [ $? -eq 0 ]; then
  echo "Home-manager switch was successful."
else
  echo "Home-manager switch failed. Please check the configuration."
  exit 1
fi

# Rebuild NixOs configuration
echo "Rebuilding NixOS configuration..."
sudo nixos-rebuild switch --flake .

# Check if nixos-rebuild was successful
if [ $? -eq 0 ]; then
  echo "NixOS rebuild was successful."
else
  echo "NixOS rebuild failed. Please check the configuration."
  exit 1
fi

