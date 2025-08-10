import pandas as pd
import os

# Folder containing CSV files
DATA_FOLDER = "data"

# 🗂 Which files get full profiling? 
FULL_PROFILING_FILES = [
    "patients.csv",
    "appointments.csv",
    "conditions.csv",
    "referrals.csv",
    "procedures.csv"
]

# Output file for all profiling results
OUTPUT_FILE = "data_profiling_report.csv"

# 📝 Profiling results storage
profiling_results = []

def profile_csv(file_path, profiling_type="light"):
    """Profiles a CSV file with either light or full checks."""
    df = pd.read_csv(file_path)

    for col in df.columns:
        col_data = df[col]
        null_count = col_data.isnull().sum()
        distinct_count = col_data.nunique()

        profile_info = {
            "file_name": os.path.basename(file_path),
            "column_name": col,
            "profiling_type": profiling_type,
            "null_count": null_count,
            "distinct_count": distinct_count
        }

        if profiling_type == "full":
            try:
                if pd.api.types.is_numeric_dtype(col_data):
                    profile_info["min_value"] = col_data.min()
                    profile_info["max_value"] = col_data.max()
                elif pd.api.types.is_datetime64_any_dtype(col_data):
                    profile_info["min_value"] = col_data.min()
                    profile_info["max_value"] = col_data.max()
                else:
                    profile_info["min_value"] = None
                    profile_info["max_value"] = None
            except Exception as e:
                profile_info["min_value"] = None
                profile_info["max_value"] = None

        profiling_results.append(profile_info)

# Loop through all CSVs in the folder
for filename in os.listdir(DATA_FOLDER):
    if filename.endswith(".csv"):
        file_path = os.path.join(DATA_FOLDER, filename)
        profiling_type = "full" if filename in FULL_PROFILING_FILES else "light"
        profile_csv(file_path, profiling_type)

# Save profiling results
report_df = pd.DataFrame(profiling_results)
report_df.to_csv(OUTPUT_FILE, index=False)

print(f"Profiling complete! Report saved to {OUTPUT_FILE}")
