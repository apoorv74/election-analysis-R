## Data directory structure

```
+---gis
|       constituency-list-datameet.csv
|       eci_geographies_standard.csv
|       india_pc_2019_simplified.geojson
|       
+---processed
|       candidate_profile_data.csv
|       constituency_analysis_file.csv
|       constituency_map_file.csv
|       constituency_master.csv
|       constituency_sub.csv
|       
\---raw
        constituency-data-summary.xls
        constituency-detailed-results.xls
```

1. **gis** - Contains constituency shape file and other files generated in the process to match geography names between data file and shape file.

2. **raw** - Contains raw files downloaded from the ECI website.

3. **processed** - Contains file generated after cleaning and processing the raw data files.
