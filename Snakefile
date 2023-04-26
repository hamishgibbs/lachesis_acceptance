import glob

rule all:
    input:
        "rulegraph.svg",
        "output/gps_data.geojson",
        "output/skmob_visits.geojson",
        "output/lachesis_visits.geojson",
        "output/lachesis_visits_release.geojson"

rule rulegraph:
    input: 
        "Snakefile"
    output:
        "rulegraph.svg"
    shell:
        "snakemake --rulegraph | dot -Tsvg > {output}"

rule gps_data: 
    input:
        "src/clean_data.py",
        glob.glob("data/raw/*.txt")
    output:
        "data/gps_data_skmob.csv",
        "data/gps_data.csv"
    shell:
        "python {input} {output}"

rule gps_data_geo:
    input:
        "src/csv_to_geojson.py",
        "data/gps_data_skmob.csv"
    output:
        "output/gps_data.geojson"
    shell:
        "python {input} lng lat 4326 {output}"

rule skmob_visits:
    input:
        "src/skmob_visits.py",
        "data/gps_data_skmob.csv"
    output:
        "output/skmob_visits.csv"
    shell:
        "time python {input} {output[0]}"

rule skmob_visits_geo:
    input:
        "src/csv_to_geojson.py",
        "output/skmob_visits.csv"
    output:
        "output/skmob_visits.geojson"
    shell:
        "python {input} lng lat 4326 {output}"

rule compile_lachesis: 
    input:
        "../lachesis/src/main.rs"
    output:
        "../lachesis/target/debug/lachesis"
    shell:
        "cd ../lachesis && cargo build"

rule compile_lachesis_release: 
    input:
        "../lachesis/src/main.rs"
    output:
        "../lachesis/target/release/lachesis"
    shell:
        "cd ../lachesis && cargo build --release"

rule lachesis_visits:
    input:
        "data/gps_data.csv",
        "../lachesis/target/debug/lachesis"
    output:
        "output/lachesis_visits.csv"
    shell:
        "time cat {input[0]} | {input[1]} 200 300 '%Y-%m-%d %H:%M:%S+00:00' > {output}"

rule lachesis_visits_release:
    input:
        "data/gps_data.csv",
        "../lachesis/target/release/lachesis"
    output:
        "output/lachesis_visits_release.csv"
    shell:
        "time cat {input[0]} | {input[1]} 200 300 '%Y-%m-%d %H:%M:%S+00:00' > {output}"

rule lachesis_visits_geo:
    input:
        "src/csv_to_geojson.py",
        "output/lachesis_visits.csv"
    output:
        "output/lachesis_visits.geojson"
    shell:
        "python {input} x y 27700 {output}"

rule lachesis_visits_release_geo:
    input:
        "src/csv_to_geojson.py",
        "output/lachesis_visits_release.csv"
    output:
        "output/lachesis_visits_release.geojson"
    shell:
        "python {input} x y 27700 {output}"