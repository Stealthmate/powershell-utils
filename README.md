## Various utility functions for powershell

#### **env** - list and modify environment variables
 - `env [array]` - When used by itself, lists all environment variables and their values. You can pass an array of names to list only specific variables.

 - `env -n [hashtable]` - You can pass a hash table of name=value pairs with `-n`, in which case each variable in the table is updated with the specified value (pass `$null` to delete a variable)

 - `env -t [mup]` - In both viewing and editing mode, passing `-t` with a string containing the letters `m`, `u` and/or `p` will make the command operate on Machine, User and/or Process variables respectively. The default value is `p`.

#### **sshtool** - list and load SSH keys
Requires the following environment variables to work:
 - `SSH_KEYS` - specifies a path to a directory containing SSH key files
 - `SSH_AGENT` - specifies a path to the SSH agent to use when loading keys. The command used for loading is `& $SSH_AGENT $key`

 - `sshtool -list` - Lists all the keys inside `SSH_KEYS`
 - `sshtool -load [array]` - Loads each key in an array of key file names. Absolute paths are supported. Relative paths are resolved with respect to `SSH_KEYS`
