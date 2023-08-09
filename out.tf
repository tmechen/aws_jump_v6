resource "local_file" "jump_ssh_key" {
  filename        = "./out/${aws_key_pair.jump_key_pair.key_name}.pem"
  content         = tls_private_key.jump_key_pair.private_key_pem
  file_permission = 0600
}

resource "local_file" "out" {
    filename = "./out/out.md"
    content  =  <<EOF
# SSH Connect
```bash
ssh -i ${aws_key_pair.jump_key_pair.key_name}.pem ec2-user@${aws_instance.jumpbox.ipv6_addresses[0]}
```
    EOF
}