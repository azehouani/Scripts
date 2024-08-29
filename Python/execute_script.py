import subprocess

def main():
    # Define the paths to the scripts you want to execute
    script_1 = 'path/to/your_script_1.py'
    script_2 = 'path/to/your_script_2.py'

    try:
        # Execute the first script
        subprocess.run(['python', script_1], check=True)
        print(f"Successfully executed {script_1}")
        
        # Execute the second script
        subprocess.run(['python', script_2], check=True)
        print(f"Successfully executed {script_2}")

    except subprocess.CalledProcessError as e:
        print(f"An error occurred while executing the scripts: {e}")

if __name__ == "__main__":
    main()
