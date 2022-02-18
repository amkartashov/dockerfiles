# Ansible in docker

Docker image with preinstalled ansible, to be used as ansible control machine.

## Usage

Provided that you have all playbook information (cfg/hosts/vault/keys/etc) in a single directory, run below commands

```bash
cd playbook_dir
# run shell
docker run -ti --rm --volume `pwd`:/ansible ghcr.io/amkartashov/ansible
# run any other command
docker run -ti --rm --volume `pwd`:/ansible ghcr.io/amkartashov/ansible ansible --version
# run playbook
docker run -ti --rm --volume `pwd`:/ansible ghcr.io/amkartashov/ansible ansible-playbook site.yml
```

If `requirements.txt` exists in playbook directory, it will install needed python modules with pip.
