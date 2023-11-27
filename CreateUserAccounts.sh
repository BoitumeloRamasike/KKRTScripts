#!/usr/bin/bash

#Access to software
groupadd -r hpcusers

#Function to create a user
create_user() {
    username=$1
    password=$2

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping."
    else
        # Create the user
        usermod -G wheel,hpcusers "$username"

        # Set the password
        echo "$username:$password" | chpasswd

        echo "User $username created successfully."
    fi
}

# Example usage
create_user "user1" "password1"
create_user "user2" "password2"
# Add more users as needed

echo "User creation script completed."
