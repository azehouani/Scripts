from cryptography.fernet import Fernet

def encrypt_secret(secret: str):
    # Generate a new Fernet key
    key = Fernet.generate_key()

    # Save the key to a file
    with open("secret.key", "wb") as key_file:
        key_file.write(key)

    # Create a Fernet cipher using the key
    cipher_suite = Fernet(key)

    # Encrypt the provided secret
    encrypted_secret = cipher_suite.encrypt(secret.encode())

    # Save the encrypted secret to a file
    with open("secret.bin", "wb") as secret_file:
        secret_file.write(encrypted_secret)

    print("✅ Encryption complete!")
    print("Key saved to: secret.key")
    print("Encrypted data saved to: secret.bin")

# Example usage
# encrypt_secret("Hello, world!")
