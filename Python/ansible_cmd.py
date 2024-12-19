import subprocess

def execute_ansible_playbook(tag, services_list):
    """
    Executes an Ansible playbook with the provided tag and services list.

    Args:
        tag (str): The tag for the Ansible playbook (e.g., "stop", "soft-start").
        services_list (list): A list of selected services to pass as an extra variable.

    Returns:
        None: Prints the result of the Ansible playbook execution.
    """
    # Convert services_list to a JSON-like string
    services_list_str = str(services_list).replace("'", '"')  # Ensures proper formatting

    # Build the Ansible playbook command
    command = [
        "ansible-playbook",
        "-l", "ops",
        "-i", "inventory/host.ini",
        "playbook/manage-services.yaml",
        "--tag", tag,
        "--extra-vars", f'{{ "java-services" : {services_list_str} }}'
    ]

    try:
        # Execute the command and capture the output
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print("Playbook executed successfully!")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("An error occurred while executing the playbook.")
        print(e.stderr)
