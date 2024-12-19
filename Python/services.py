def display_service_menu():
    """Display the service menu in 3 columns and return the user's selected services."""
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

    # Display the menu in 3 columns
    print("\nChoose one or more services to manage (use ',' as a delimiter, e.g., 1,2,3):")
    service_items = list(services.items())
    for i in range(0, len(service_items), 3):
        # Take 3 items at a time
        row = service_items[i:i + 3]
        # Format each item to align properly
        formatted_row = [f"{key}) {value.split('-')[1].capitalize() if '-' in value else value.capitalize():<20}" for key, value in row]
        print("  ".join(formatted_row))

    # User input and validation
    while True:
        service_input = input("\nEnter the numbers corresponding to the services: ").strip()
        selected_keys = [s.strip() for s in service_input.split(",")]

        # Validate all inputs
        if all(key in services for key in selected_keys):
            if "0" in selected_keys:  # If "ALL" is selected
                return "ALL"
            return [services[key] for key in selected_keys]
        print("Invalid service selection. Please try again.\n")
