import os
import pandas as pd

path = "data"

def aggregate(files: list):
    dataframes = []
    for f in files:
        try:
            is_filename_ok(f)
            store = extract_store_from_suffix(f)
            df = pd.read_csv(f"data/{f}")
            print(df)
            df['magasin'] = store
            dataframes.append(df)
            
            
        except DataFileException as dfe:
            print(dfe)

    return pd.concat(dataframes, ignore_index=True)


def is_filename_ok(filename: str):
    if filename.lower().endswith(".csv"):
        return True
    else:
        raise DataFileException("Nope csv")

def extract_store_from_suffix(filename: str):
    name = filename.split(".")[0]
    if name:
        return name[-1]
    else:
        raise DataFileException("invalid filename")

class DataFileException(Exception):
    pass


def main():
    files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
    
    df = aggregate(files)
    df.drop_duplicates()
    df.dropna()
    df["montant_total"] = df["quantite"] * df["prix_unitaire"]
    print(df)

    total_by_store = df.groupby('magasin')['montant_total'].sum()
    print(total_by_store)

    total_by_vendeur = df.groupby('vendeur')['montant_total'].sum()
    print(total_by_vendeur)

    top_produits = df.groupby('produit')['montant_total'].sum()
    print(top_produits)

    with pd.ExcelWriter('tp1_result.xlsx') as writer:
        df.to_excel(writer, sheet_name='Consolidé', index=False)
        total_by_store.to_excel(writer, sheet_name='Par magasin', index=True)
        total_by_vendeur.to_excel(writer, sheet_name='Par vendeur', index=True)
        top_produits.to_excel(writer, sheet_name='Par produit', index=True)


if __name__=="__main__":
    main()

