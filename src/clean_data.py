import sys
import pandas as pd
from convertbng.util import convert_bng


def read_data(fn):
    return pd.read_csv(fn, 
        skiprows=1,
        usecols=[0, 1, 3],
        names = ["lat", "lon", "time"])

def main():

    in_fns = sys.argv[1:-2]
    
    df = pd.concat([read_data(fn) for fn in in_fns])

    df.dropna(inplace=True)

    df["id"] = 1

    df["time"] = pd.to_datetime(df["time"])

    df.sort_values(by="time", inplace=True)

    # Save gps data in a format for skmob
    df.to_csv(sys.argv[-2], index=False)

    # Convert lon and lat coords to BNG
    res_list = convert_bng(df["lon"].to_numpy(), df["lat"].to_numpy())

    df["x"] = res_list[0]
    df["y"] = res_list[1]
    
    df.dropna(inplace=True)

    # Save gps data in a format for lachesis
    df[["id", "time", "x", "y"]].to_csv(sys.argv[-1], index=False)

if __name__ == '__main__':
    main()