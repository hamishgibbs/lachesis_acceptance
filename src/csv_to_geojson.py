import sys
import pandas as pd
import geopandas as gpd

def main():
    
    df = pd.read_csv(sys.argv[1])

    geonames = sys.argv[2:4]
    crs = sys.argv[4]

    gdf = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df[geonames[0]], df[geonames[1]]))
    gdf.set_crs(crs, inplace=True)
    gdf.to_crs(27700).to_file(sys.argv[-1], driver="GeoJSON")

if __name__ == "__main__":
    main()