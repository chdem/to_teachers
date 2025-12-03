## TP 1 - Pipeline CSV vers Excel

**Objectif** : Créer un pipeline de traitement automatisé

**Contexte** : Vous recevez quotidiennement des fichiers CSV de différentes sources (magasins) et devez les consolider dans un rapport Excel.

**Fichiers d'entrée** : `magasin_A.csv`, `magasin_B.csv`, `magasin_C.csv`

**Colonnes** : date, produit, quantite, prix_unitaire, vendeur

**Pipeline à construire** :
1. Charger tous les fichiers CSV
2. Ajouter une colonne `magasin` (A, B ou C)
3. Concaténer tous les DataFrames
4. Nettoyer (doublons, valeurs manquantes)
5. Calculer `montant_total`
6. Créer un rapport Excel avec :
   - Feuille "Consolidé" : Toutes les données
   - Feuille "Par magasin" : Totaux par magasin
   - Feuille "Par vendeur" : Performance des vendeurs
   - Feuille "Top produits" : 10 produits les plus vendus