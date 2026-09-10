## **Automatisation de la logique de calcul d'un reporting commercial trimestriel : SQL & Chinook Database**

## **Contexte**

Ce projet répond à une problématique (fictive)  simple : une entreprise souhaite produire un rapport de ventes par produit pour le dernier trimestre, sans recalculer les chiffres à la main à chaque fois. La base utilisée est Chinook, une base de données représentant un magasin de musique en ligne (clients, factures, morceaux, artistes, agents commerciaux).

L'objectif est double. D'abord, extraire et agréger les données de vente avec SQL. Ensuite, transformer ce travail en système réutilisable, plutôt qu'en une série de requêtes ponctuelles.

## **Démarche**

Le projet se divise en deux parties.

La première partie regroupe des requêtes classiques : filtrage de clients, comptage de factures, jointures entre tables. Ces requêtes servent à se familiariser avec la structure de la base et à répondre à des questions ponctuelles. Elles n'ont pas vocation à être réutilisées.

La deuxième partie concerne le reporting proprement dit. Cinq vues SQL ont été créées avec ‘`CREATE VIEW’`, chacune correspondant à un indicateur métier récurrent :

- `VueVentesParAgent` : ventes totales par agent commercial  
- `VueVentesParPays` : ventes totales par pays  
- `VueTopMorceaux` : morceaux les plus vendus  
- `VueTopArtistes` : artistes les plus vendus  
- `VueVentesParProduitDernierTrimestre` : ventes par produit sur une période donnée

Une vue stocke la logique d'une requête complexe sous un nom. Une fois créée, elle peut être interrogée comme une table normale, avec un simple `SELECT * FROM [NomDeLaVue]`. Si les données de la base changent, la vue reflète ces changements sans qu'il soit nécessaire de réécrire la requête. Le calcul est automatisé.

## **Une correction méthodologique**

Au cours du projet, une erreur a été identifiée dans la vue `VueVentesParProduitDernierTrimestre`. Le regroupement se faisait initialement sur `Track.TrackId`, l'identifiant unique du morceau. Or plusieurs morceaux distincts peuvent porter le même nom dans Chinook. Le regroupement par identifiant produisait donc des lignes séparées pour un même titre, avec des totaux qui semblaient incohérents.

La correction a consisté à regrouper directement sur `Track.Name`. 

**Limites**

La base Chinook contient des données allant jusqu'en 2013 environ. La notion de "dernier trimestre" a donc été fixée sur une période réelle de la base (octobre à décembre 2013), plutôt que calculée par rapport à la date du jour. Dans un contexte de production, cette vue utiliserait une condition du type `date('now', '-3 months')` pour s'adapter automatiquement à la période courante.

Une autre limite concerne la diffusion du rapport. Les vues automatisent le calcul, mais leur consultation reste manuelle. Une automatisation complète nécessiterait un script planifié, par exemple en Python, pour générer et envoyer le rapport à intervalle régulier.

## **Résultats**

Les résultats des cinq vues ont été exportés et représentés sous forme de graphiques.

Le graphique des ventes par agent montre un écart d'environ 15 à 20 % entre l'agent le plus performant et les autres, une fois l'axe des ordonnées correctement fixé à zéro.

Le classement des morceaux les plus vendus montre des écarts faibles entre les dix premiers titres, ce qui reflète probablement une base de données avec un grand nombre de morceaux achetés un petit nombre de fois chacun.

## **Compétences mobilisées**

* Requêtes SQL : `SELECT`, `WHERE`, `JOIN`, `GROUP BY`, `HAVING`  
* Calcul d'agrégats : `SUM`, `COUNT`  
* Création et gestion de vues SQL (`CREATE VIEW`, `DROP VIEW`)  
* Détection et correction d'une erreur de regroupement de données  
* Représentation de données sous forme de graphiques, avec attention portée aux choix d'échelle et de type de graphique

