# Chef configuration management

This cookbook configures a Linux node with Docker and starts the demo app from a local Docker image. It is a teaching example: the Terraform launch template currently uses cloud-init/systemd for a self-contained health service, not Chef Server enrollment.

## Use

1. Install Chef Workstation and a Chef Infra Client on a disposable Linux test VM.
2. Build or pull your application image and make it available to the node.
3. Update `attributes/default.rb` with the image and port.
4. Run locally in a test VM:

```bash
sudo chef-client --local-mode --runlist 'recipe[self_healing_demo]'
```

For fleet-wide use, bootstrap nodes into Chef Infra Server and use managed cookbooks, policyfiles, secrets handling, and node roles. Never store credentials in cookbook attributes.
