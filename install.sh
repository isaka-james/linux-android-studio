#!/bin/bash


if [ "$(id -u)" -ne 0 ]; then
    echo -e "You should run as \e[0;101m\e[1;97mroot\e[0m\e[0m!"
    echo -e "Don't worry, we won't install 'android-studio' in root.."
    exit 1
fi





check_android_studio_folder() {
    local folder_name="android-studio"

    # Check if the folder exists
    if [ -d "$1/$folder_name" ]; then
        echo -e "\t\t$tool: \"$folder_name\" was found.."

        # Check for studio.sh inside bin directory
        check_studio_sh "$1/$folder_name"
    else
        echo -e "\t\t$tool: The '$folder_name' folder is not found in the provided directory. Please provide a valid path."
        exit 1
    fi
}

check_studio_sh() {
    local studio_sh_path="$1/bin/studio.sh"

    # Check if studio.sh exists
    if [ -f "$studio_sh_path" ]; then
        echo -e "\t\t$tool: 'studio.sh' file is present inside the 'bin' directory.."
    else
        echo -e "\t\t$tool: The 'studio.sh' file is not found in the 'bin' directory of 'android-studio'.."
        exit 1
    fi
}



finish_installation()
{
        # INSTALLATION START

        # Check if the 'android-studio' exists in /opt
        if [ -d "/opt/android-studio" ]; then
            echo -e "\t\t$tool: 'android-studio' folder was found existing in /opt .."

            rm -rf "/opt/android-studio"
            echo -e "\t\t$tool: 'android-studio' folder was deleted in /opt .."

        fi

        echo -e "\t\t$tool: copying the 'android-studio' to /opt .."   
        cp -r "$custom_link" "/opt"
        echo -e "\t\t$tool: 'android-studio' folder was copied from $custom_link to /opt .."
        



        # Now making the enviroment variables finishing the installations

        # Handling the /sbin logic
        sbin_contents="/opt/android-studio/bin/studio.sh"
        sbin_file="/sbin/studio"

        echo -e "\t\t$tool: adding the enviroment variable 'studio' to the system .."

        rm -rf "$sbin_file"
        echo "$sbin_contents">>"$sbin_file"

        echo -e "\t\t$tool: Successfully added the enviroment variable .."

        chmod 777 "$sbin_file"

        chmod +x "/opt/android-studio/bin/studio.sh"
        chmod +x "$sbin_file"


        echo -e "\t\t$tool: Installation complete!"
        echo -e "\t\t$tool: Now you can type 'studio' to open 'android-studio'"
}



tool="linux-android-studio"
custom_link=""


echo -e "\n\tStarting[$tool]..\n"

# The default directory to check the android-studio folder
downloads_dir="$HOME/Downloads"

# Check if the folder exists in the Downloads directory
if [ -d "$downloads_dir/android-studio" ]; then
    echo -e "\t\t$tool: 'android-studio' folder was found in Downloads directory.."

    # Check for studio.sh inside bin directory
    check_studio_sh "$downloads_dir/android-studio"
    custom_link="$downloads_dir/android-studio"
    finish_installation
else
    #echo -e "\t\t$tool: 'android-studio' folder was not found in the Downloads directory."

    # Ask the user for the correct path
    read -p "         Please enter the full path to the 'android-studio' folder: >>  " user_path

    # Check if the entered path is valid
    if [ -d "$user_path" ]; then
        check_android_studio_folder "$user_path"
        
        # The user has the valid android-studio : success 
        custom_link="$user_path/android-studio"
        finish_installation
    else
        echo -e "\t\t$tool: \"$user_path\" directory was not found!"
        exit 1
    fi
fi

