import hvac

# Define Vault connection and AppRole details
VAULT_ADDR = "https://your-vault-server:8200"
ROLE_ID = "your-role-id"
SECRET_ID = "your-secret-id"
SECRET_PATH = "secret/data/your-secret-path"  # Replace with your actual secret path

def fetch_secret_from_vault():
    try:
        # Initialize the Vault client
        client = hvac.Client(url=VAULT_ADDR)

        # Authenticate using AppRole
        response = client.auth.approle.login(role_id=ROLE_ID, secret_id=SECRET_ID)
        if not client.is_authenticated():
            raise Exception("Authentication failed. Please check your AppRole credentials.")

        print("Successfully authenticated with Vault!")

        # Fetch the secret
        secret = client.secrets.kv.read_secret_version(path=SECRET_PATH)
        secret_data = secret['data']['data']  # Adjust based on your KV version
        print("Secret fetched successfully!")
        return secret_data
    except Exception as e:
        print(f"Error fetching secret: {e}")
        return None

if __name__ == "__main__":
    secret = fetch_secret_from_vault()
    if secret:
        print("Fetched Secret:")
        print(secret)
    else:
        print("No secret was retrieved.")
