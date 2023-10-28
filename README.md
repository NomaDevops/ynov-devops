# Correction

## Terraform

## Helm Chart

## KubeConfig

## Rappel des commandes 
| commande | Description |
|----|-----|
| terraform init | Initialise terraform dans le dossier courant |
| terraform validate . | Verifie la syntaxe des fichier terraform |
| terraform plan | Affiche ce que va deployer terraform |
| terraform apply | Deploie les resources ecrite dans terraform |
| terraform destroy | Detruis les resources ecrite dans terraform |
| helm create nom_chart | Cree un nouveau repo helm |
| helm install NAME nom_chart | Installe le chart nom_chart au nom de NAME dans kubernetes |
| helm upgrade NAME nom_chart | Update le chart nom_chart au nom de NAME dans kubernetes avec les nouvelles valeurs |
| helm uninstall nom_chart | Supprime le chart nom_chart dans kubernetes ainsi que les pods |
| helm rollback nom_chart | Reviens a la version precedente du chart |