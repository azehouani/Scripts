def display_main_menu():
    """Display the main menu and return the user's choice."""
    print("Please choose an option:")
    print("1) Stop")
    print("2) Soft-start")
    print("3) Force-start")
    while True:
        choice = input("Enter the number corresponding to your choice: ").strip()
        if choice in {"1", "2", "3"}:
            return choice
        print("Invalid choice. Please enter 1, 2, or 3.\n")


def display_service_menu():
    """Display the service menu and return the user's selected services."""
    services = {
        "0": "ALL",
        "1": "ilc-payment-integrateur",
        "2": "ilc-advice-integrateur",
        "3": "ilc-balance-integrateur",
        "4": "ilc-cls-position-integrateur",
        "5": "ilc-ews-integrateur",
        "6": "ilc-intraday-integrateur",
        "7": "ilc-is-file-integrateur"
    }

    print("\nChoose one or more services to manage (use ',' as a delimiter, e.g., 1,2,3):")
    for key, value in services.items():
        print(f"{key}) {value.split('-')[1].capitalize() if '-' in value else value.capitalize()}")

    while True:
        service_input = input("Enter the numbers corresponding to the services: ").strip()
        selected_keys = [s.strip() for s in service_input.split(",")]

        # Validate all inputs
        if all(key in services for key in selected_keys):
            if "0" in selected_keys:  # "ALL" option selected
                return list(services.values())[1:]  # Exclude "ALL" itself
            return [services[key] for key in selected_keys]
        print("Invalid service selection. Please try again.\n")



def process_selection(action_choice, selected_services):
    """Process and display the chosen action and services."""
    actions = {
        "1": "Stop",
        "2": "Soft-start",
        "3": "Force-start"
    }

    print(f"\nYou selected the action: {actions[action_choice]}")
    print("Selected services (as list object):")
    print(selected_services)  # Print services as a single Python list


def main():
    """Main function to execute the script workflow."""
    # Step 1: Main menu selection
    action_choice = display_main_menu()

    # Step 2: Service menu selection
    selected_services = display_service_menu()

    # Step 3: Process and display the results
    process_selection(action_choice, selected_services)


if __name__ == "__main__":
    main()
