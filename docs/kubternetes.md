# pyenv and ansible
```
python3 -m venv ~/p3.9
pipx install  ansible
```

```
ansible tutorial
https://spacelift.io/blog/ansible-tutorial
```

```
https://github.com/containerd/containerd/issues/8139 # if the containerd is not starting error is reported when trying to init with kubeadm.
#
if the apt-key and apt-add-repository not working, delete the /etc/apt/sources.d/docker/kubermetes.list
- gpg dearmor is not needed if the key is saved as asc file instead of gpg. gpg is binary file.
update_cache is for `sudo apt-get update`
```