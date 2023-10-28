# Correction

## Dockerfile
Le dockerfile doit forcement avoir un argument FROM vous pouvez partir directement d'une image python ou depuis l'image de quelqu'un d'autre.
```dockerfile
FROM <repo>/<image>:<tag>
```

L'argument RUN va nous permettre d'installer les dependances pip manquante, c'est l'equivalent d'une ligne de commande a executer sur le container.
```dockerfile
RUN <commande linux>
```

Pour copier le code source vous pouvez utiliser l'argument COPY ou ADD dans les deux cas le format sera le suivant: ```dockerfile 
COPY <source> <destination>
``` ou source est votre machine et destination et sur le container.

Enfin l'argument HEALTHCHECK va permettre de faire une verification de la sante du container.
```dockerfile
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```
Cette ligne signifie que toute les 5 minutes on executera ```curl -f http://localhost/``` et on veut une reponse en moins de 3 secondes. Si il n'y a pas de reponse alors on declenche une erreur avec ```exit 1```

## Docker compose
Le docker compose va nous permettre de lancer plusieurs service et de passer des variables d'environnements a nos containers pour qu'ils fonctionnent correctement.

On definit deux services, un premier pour Redis qui est notre base de donnees.

Et le deuxieme qui est notre container. Puisque c'est un container qu'on build nous meme on lui passe l'argument ```build .``` ce qui fait que lorsque on lancera la commande ```docker compose up``` si l'image n'existe pas il va la creer pour nous.
Attention cependant au cache de Docker.
Enfin on passe notre variable d'environnement REDIS a notre container en faisant une reference au nom de notre service Redis
```REDIS: azure-vote-back``` attention pensez a ne pas mettre les guillemets sinon Docker interpretera ça comme une chaine de texte.

## Rappel des commandes 
| commande | Description |
|----|-----|
| docker build -t repos/image:tag . | Build une image Docker|
| docker rmi repos/image:tag | Supprime une image docker|
| docker ps | Liste les containers actif|
| docker rm container_id | Supprime un container|
| docker compose up | Lance tous les services definit dans le fichier compose |
| docker compose down | Supprime tous les services definit dans le fichier compose |
| docker compose stop | Arrete tous les services definit dans le fichier compose |
| docker compose build | Lance le build de tous les services ayant l'argument build |