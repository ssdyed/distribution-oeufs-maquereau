# Distribution des oeufs de maquereau
Projet de session du cours de régression linéaire 
Université de Montréal


## Objectif

Analyser la distribution des œufs de maquereau à l'aide de méthodes de régression linéaire multiple afin d'identifier les facteurs environnementaux qui expliquent la densité des œufs (`egg.dens`) dans l'Atlantique Nord-Est européen.


## Données

Les données proviennent d'une enquête européenne visant à évaluer la biomasse du stock reproducteur de maquereau via la méthode de production journalière d'œufs.

- **369 observations**, **11 variables**
- Variable réponse : `egg.dens` (œufs/m²/jour)
- Variables explicatives : profondeur, coordonnées géographiques, température, distance au contour 200m, etc.



## Méthodologie

1. **Nettoyage des données** : valeurs manquantes, doublons, outliers
2. **Analyse exploratoire (EDA)** : distribution de Y, corrélations, nuages de points des Xi et la variable réponse
3. **Transformation des variables** — log(egg.dens), log(b.depth), exclusion de `flow` et `temp.20m`
4. **Sélection du modèle** : algorithme stepwise bidirectionnel (AIC) + analyse VIF
5. **Validation du modèle** : résidus, QQ-plot, distance de Cook
6. **Interprétation** : les coefficients de l'équation du modèle retenu dans le contexte biologique marin



## Modèle final

```
log(egg.dens) = 8.433 + 0.413·log(b.depth) − 0.180·lat − 0.211·lon − 0.793·c.dist
```

- **R²ajusté = 0.301** : pouvoir explicatif modéré
- **VIF < 3** pour toutes les variables : multicolinéarité résolue (ce n'était pas le cas pour les autres modèles)
- Toutes les variables significatives à α = 0.05



## Logiciel

- **R** (version 4.5.2) via RStudio
- Packages : `readr`, `corrplot`, `car`



## Auteur

Yves Sery
