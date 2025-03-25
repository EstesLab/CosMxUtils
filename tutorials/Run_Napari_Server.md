on local machine Edit your ~/.ssh/config

For access to OHSU servers:
Host monkeydo.ohsu.edu
    ProxyJump usermane@acc.ohsu.edu
    ForwardX11 yes
    ForwardX11Trusted yes

