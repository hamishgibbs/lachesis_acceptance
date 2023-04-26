import sys
import pandas as pd
import skmob
from skmob.preprocessing import detection


def main():

    df = pd.read_csv(sys.argv[1])

    tdf = skmob.TrajDataFrame(df, 
        latitude='lat', 
        longitude='lon', 
        datetime='time', 
        user_id='id')

    stdf = detection.stay_locations(tdf, 
        minutes_for_a_stop=5.0, 
        spatial_radius_km=0.2, 
        leaving_time=True)

    stdf.to_csv(sys.argv[-1], index=False)

if __name__ == "__main__":
    main()
    

