packsDir: moduleName:
if builtins.pathExists packsDir then
  let
    entries = builtins.readDir packsDir;
    packNames = builtins.filter (n: entries.${n} == "directory") (builtins.attrNames entries);
    resolve =
      name:
      let
        dirPath = packsDir + "/${name}/${moduleName}";
        filePath = packsDir + "/${name}/${moduleName}.nix";
      in
      if builtins.pathExists dirPath then
        dirPath
      else if builtins.pathExists filePath then
        filePath
      else
        null;
  in
  builtins.filter (p: p != null) (map resolve packNames)
else
  [ ]
