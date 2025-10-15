
# Vault Secret Retrieval Script

## 📋 Requirements

- **Python**: 3.x.x  
- **Environment Variables** (to be exported before running the scripts):

  ```bash
  export VAULT_NAMESPACE=<your_vault_namespace>
  export GET_VAULT_SECRET=vault_get_secret.py
  export VAULT_ADDR=<your_vault_address>
  export ROLE_ID=<your_role_id>
  ```

## 📦 Installation

Install the required Python packages:

```bash
python -m pip install hvac pip-system-certs cryptography
```

---

## 🚀 Usage Steps

### Step 1 — Get the Secret ID

1. Connect to your **Vault UI** or **CLI dashboard**.  
2. Execute the following command to generate a secret ID for your AppRole:

   ```bash
   vault write -f auth/approle/role/ROLE_NAME/secret-id
   ```

   > 💡 To list available role names, use:
   >
   > ```bash
   > vault list auth/approle/role/
   > ```

---

### Step 2 — Clone and Execute the Script

1. Clone the project repository:
   ```bash
   git clone <repository_url>
   cd <project_folder>
   ```

2. Run the configuration script:
   ```bash
   python iit-tools/security_management/config/config_vault.py
   ```

   The script will prompt you to enter the **secret ID** generated from Vault UI.

---

### Step 3 — Inject Secret into Environment Variable

To inject the secret from Vault into an environment variable, execute the following command:

```bash
SECRET_ID=$(python3 $GET_VAULT_SECRET scripts/sgconnect secret_id)
```

This command retrieves the secret from Vault and exports it into your current environment for use in other scripts or processes.

---

## 🧠 Notes

- Ensure that your Vault token and role configurations are correctly set up before running these scripts.
- Use a secure environment to handle secret values.
- For troubleshooting, verify Vault address and namespace configurations.

---

## 🛠️ Example Directory Structure

```
project/
│
├── iit-tools/
│   └── security_management/
│       └── config/
│           └── config_vault.py
│
├── scripts/
│   └── sgconnect
│
└── vault_get_secret.py
```

---

**Author:** Internal DevOps Team  
**Version:** 1.0.0  
**License:** Private / Internal Use Only

