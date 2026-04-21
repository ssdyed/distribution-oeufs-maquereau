# PARTIE 1 : VÉRIFICATION ET NETTOYAGE DES DONNÉES

# Chargement des données
library(readr)
maquereau = read_csv("maquereau.csv")

# Structure des données
dim(maquereau)                  # dimension de notre matrice de données
str(maquereau)                 # on vérifie que toutes les varibales sont bien reconnues comme numériques

# Enlever la première colonne des index
maquereau = maquereau[, names(maquereau) != "...1"]

# Valeurs manquantes et doublons
sum(is.na(maquereau))
sum(duplicated(maquereau))
# On obtient 0 pour les deux fonctions. On a donc 0 valeur manquante et 0 doublon.

# Résumé statistique des données
summary(maquereau)


# PARTIE 2 : ANALYSE EXPLORATOIRE

# Distribution de egg.dens
maquereau$log_egg = log(maquereau$egg.dens)          # colonne de log(egg.dens)

par(mfrow=c(1,2))

hist(maquereau$egg.dens, main = "Histogramme de la densité des oeufs")
hist(maquereau$log_egg, main = "Histogramme de la densité des oeufs au logarithme")

par(mfrow=c(1,1))

# Matrice de corrélation
library(corrplot)

matrice_cor = cor(maquereau)
round(matrice_cor, 2)                                  # arrond à 2 décimales

# Visualiser les corrélations avec des couleurs
corrplot(matrice_cor, method = "color", type = "upper", addCoef.col = "black",
         tl.cex = 0.7,number.cex = 0.8)

# Nuages de points de toutes les variables contre Y
variables = names(maquereau)

par(mfrow = c(2, 5))
for (v in variables) {
  if (v != "egg.dens" && v != "log_egg") {
    x = maquereau[[v]]
    y = maquereau$egg.dens
    plot(x, y,
         xlab = v,
         ylab = "egg.dens",
         main = paste("egg.dens vs", v))
    abline(lm(y ~ x), col = "red")
  }
}

par(mfrow = c(2, 5))
for (v in variables) {
  if (v != "egg.dens" && v != "log_egg") {
    x = maquereau[[v]]
    y = maquereau$log_egg
    plot(x, y,
         xlab = v,
         ylab = "log_egg",
         main = paste("log_egg vs", v))
    abline(lm(y ~ x), col = "red")
  }
}
par(mfrow = c(1, 1))


# PARTIE 3 : TRANSFORMATION DES VARIABLES

# Transformation de b.depth
maquereau$log_bdepth = log(maquereau$b.depth)

# Vérification visuelle du choix de log(b.depth)
par(mfrow = c(1, 2))

plot(maquereau$b.depth, maquereau$log_egg,
     main = "log_egg vs b.depth",
     xlab = "b.depth", ylab = "log(egg.dens)")
abline(lm(log_egg ~ b.depth, data = maquereau), col = "red", lwd = 2)

plot(maquereau$log_bdepth, maquereau$log_egg,
     main = "log_egg vs log(b.depth)",
     xlab = "log(b.depth)", ylab = "log(egg.dens)")
abline(lm(log_egg ~ log_bdepth, data = maquereau), col = "red", lwd = 2)

par(mfrow = c(1, 1))


# PARTIE 4 : SÉLECTION DU MODÈLE

# Construction du modèle complet (sans flow et temp.20m) et avec les transformations
modele_complet = lm(log_egg ~ log_bdepth + lat + lon + time + s.depth +
                     temp.surf + net.area + c.dist, data = maquereau)

# Alogorithme stepwise
modele_step = step(modele_complet, direction = "both", trace = 1)
summary(modele_step)
summary(modele_complet)

# VIF sur le modèle issu du stepwise
library(car)
vif(modele_step)


# Modèle 2 : modèle complet sans lat
modele_v2 = lm(log_egg ~ log_bdepth + lon + time + s.depth +
                  temp.surf + net.area + c.dist, data = maquereau)
summary(modele_v2)
vif(modele_v2)


# Modèle 3 : modèle complet sans net.area
modele_v3 = lm(log_egg ~ log_bdepth + lat + lon + time + 
                  s.depth + temp.surf + c.dist, data = maquereau)
summary(modele_v3)
vif(modele_v3)


# Modèle 4 : modèle 3 sans lon et time
modele_4 <- lm(log_egg ~ log_bdepth + lat + s.depth + 
                 temp.surf + c.dist, data = maquereau)
summary(modele_4)
vif(modele_4)


# Modèle 5 : modèle 3 sans temps.surf et time
modele_5 = lm(log_egg ~ log_bdepth + lat + s.depth + lon 
              + c.dist, data = maquereau)
summary(modele_5)
vif(modele_5)


# Modèle 6 : modèle 3 sans temps.surf et s.depth
modele_6 = lm(log_egg ~ log_bdepth + lat + lon 
              + c.dist, data = maquereau)
summary(modele_6)
vif(modele_6)

# Le modèle 6 a été retenue comme modèle, car il garantit la stabilité des coefficients
modele_final = modele_6



# PARTIE 5 : VALIDATION DU MODÈLE

#Graphique Q-Q et graphique Résidues Vs valeur prédite
par(mfrow=c(1,2))

plot(modele_6, which = 2)
plot(modele_6, which = 1)

par(mfrow=c(1,1))

#Distance cook : 
distances_cook <- cooks.distance(modele_6)
seuil_relatif = 4 /nrow(maquereau)                         # seuil = 4/n
seuil_absolu = 1                                           # par définition

# Graphique des distances de cook
plot(distances_cook, type = "h", 
     main = "Distances de Cook", ylab = "Di")
abline(h = seuil_relatif, col = "red")
abline(h = seuil_absolu, col = "blue")                  
# Le seuil absolu n'est pas visible sur le graphique, car on est très loin de 1 (max = 0.04)
# Ce qui confirme qu'on a aucune valeur influente extrême.

# Vérification des points influents
points_influents = which(distances_cook > 1)
points_influents                                         # 0 points influents









