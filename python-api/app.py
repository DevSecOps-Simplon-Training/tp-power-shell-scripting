from flask import Flask, jsonify
import json
import os

app = Flask(__name__)

# Chargement de la configuration partagée (config.json à la racine du projet)
config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'config.json')
with open(config_path, 'r') as f:
    config = json.load(f)

# -------------------------------------------------------
# Analyse un fichier de logs serveur et retourne
# le nombre d'errors, warnings et infos détectés.
# -------------------------------------------------------

def parse_logs(filepath):
    erreurs = []
    warnings = []
    infos = []

    with open(filepath, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if "ERROR" in line:
                erreurs.append(line)
            elif "WARNING" in line:
                warnings.append(line)
            elif "INFO" in line:
                infos.append(line)

    return {
        "error_count": len(erreurs),
        "warning_count": len(warnings),
        "info_count": len(infos),
        "errors": erreurs,
        "warnings": warnings
    }


@app.route("/api/logs", methods=["GET"])
def get_logs():
    result = parse_logs(config["api"]["log_file"])
    return jsonify(result), 200


if __name__ == "__main__":
    app.run(debug=True, port=config["api"]["port"])
