import os, pickle, hashlib

def processed_path(output_folder: str, base: str) -> str:
    return os.path.join(output_folder, f"{base}_processed_data.pkl")

def load_cache(path: str) -> dict:
    if os.path.isfile(path):
        with open(path, "rb") as f:
            obj = pickle.load(f)
        if "vars" not in obj:  # migrate old style dicts
            obj = {"vars": obj, "meta": {}}
        obj.setdefault("vars", {})
        obj.setdefault("meta", {})
        return obj
    return {"vars": {}, "meta": {}}

def save_cache(path: str, cache: dict) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        pickle.dump(cache, f, protocol=pickle.HIGHEST_PROTOCOL)

def sha1_of_file(filepath: str) -> str:
    h = hashlib.sha1()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(1<<20), b""):
            h.update(chunk)
    return h.hexdigest()
