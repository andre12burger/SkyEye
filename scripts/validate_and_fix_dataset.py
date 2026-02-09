import os
import json

# Paths
front_json_path = "/home/pdi-05/Documentos/automni/SkyEye/skyeye/data/img/front.json"
dataset_root = "/media/pdi-05/dcf281c2-bfc4-4072-808b-68681ee0a523/DATASETS/automni/kitti360_original"
missing_files_log = "/home/pdi-05/Documentos/automni/SkyEye/missing_files_fixed.log"

# Load front.json
with open(front_json_path, "r") as f:
    front_data = json.load(f)

missing_files = []

# Validate and fix dataset
for entry in front_data:
    for key, relative_path in entry.items():
        full_path = os.path.join(dataset_root, relative_path)
        if not os.path.exists(full_path):
            missing_files.append(full_path)
            # Attempt to locate the file elsewhere
            file_name = os.path.basename(relative_path)
            find_command = f"find {dataset_root} -name \"{file_name}\""
            result = os.popen(find_command).read().strip().split("\n")
            if result:
                # Use the first valid result
                source_path = result[0]
                os.makedirs(os.path.dirname(full_path), exist_ok=True)
                os.rename(source_path, full_path)
                print(f"Moved: {source_path} -> {full_path}")
            else:
                print(f"File not found: {file_name}")

# Log missing files
with open(missing_files_log, "w") as log:
    log.write("\n".join(missing_files))

print(f"Validation and fixing complete. Missing files logged to {missing_files_log}.")