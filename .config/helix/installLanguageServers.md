# gopls
Ensure that the following are added to your bashrc, this will make gopls discoverable by helix

The install command for gopls is: 

```bash
go install golang.org/x/tools/gopls@latest
```

It can also be found [here](https://pkg.go.dev/golang.org/x/tools/gopls#section-readme)

```bash
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```
