import subprocess
from datetime import datetime, timedelta
import sys

def main():
    if len(sys.argv) != 3:
        print("Usage: python run_script_by_date.py <dateDebut> <dateFin>")
        print("Example: python run_script_by_date.py 2025-04-01 2025-10-01")
        sys.exit(1)

    date_debut = datetime.strptime(sys.argv[1], "%Y-%m-%d")
    date_fin = datetime.strptime(sys.argv[2], "%Y-%m-%d")

    current_date = date_debut
    while current_date <= date_fin:
        date_str = current_date.strftime("%Y-%m-%d")
        print(f"➡️ Execution du script pour la date : {date_str}")
        
        # Exécute ton script shell
        subprocess.run(["sh", "script.sh", date_str], check=True)

        current_date += timedelta(days=1)

if __name__ == "__main__":
    main()
