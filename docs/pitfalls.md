# Pitfalls

- All the remote-exec are ran as /bin/sh and even if the script that we are executing has /bin/zsh or /bin/bash there is no way to override this. So config files of zsh or bash are not loaded. Only way of using newly added binaries from different paths, is to create a symlink.
- Resources are targets, you can apply/destroy a single target with -target flag. For multiple targets in the same command, use target flag multiple times each with new argument.
- default is to create resources in parallel. So if we are running apt-get, the lock might be held by other process. Be cautious of this. Simple solution is to only have one apt-get process and others waiting for this due to dependency.
- for running some commands in script as different user, use:
```
sudo su - postgres <<< (here document) # or
sudo su - postgres -c "command"'
```
- pg_hba.conf, if thre are two rules for a user in pg_hba.conf. First rule takes preference over the last rule.