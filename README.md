![gitmr-logo](./gitmr-logo-200x200.png)

Give us a star!🌟

---

# What it is Git-MR?
Git-MR is a git command to create git merge requests from the terminal.<br/>
It makes you a more productive developer.<br/>
Git-MR is a fast, safe, and fun way to create git merge requests.<br/>

* The actual version supports Gitlab only. Support for Github will be coming in the next release.
* This tool is created for linux/unix operating systems. Support for windows will be coming in the next release.

> The idea behind Git-MR, is that you don't have to leave your terminal to submit your merge requests.
> Everything can be done from the terminal ❤️.

---

# How to install it?
Copy paste this command into your terminal:<br/>
```
sudo git clone https://github.com/MostafaACHRAF/Git-MR /bin/gitmr && sudo chmod +x /bin/gitmr/installer.sh && sh /bin/gitmr/installer.sh
```
---

Or you can try it using docker:<br/>
```
docker run --rm -it --name gitmrc -v $PWD:/workspace -v ~/Documents:/config -t gitmr
```
* ~/Documents is where gitmr will store and read it's configuration.
* The workspace folder represent your gitlab/github project folder. By default it takes the actual folder as the workspace, but you can change it.

---

Or you can create an alisa in your ~/.bashrc, ~/.zshrc or whatever shell you use:<br/>
```
gitmr() {...}
```

---

# How to use it?
After installing the tool on your machine. You can use 'git mr' as a terminal command.<br/>
Or start a new docker container and enjoy gitmr like this:<br/>

### On terminal:
```
git mr --lab -t target_branch -s source_branch -a assignee_user -l labels -m title --wip
```

### Docker without alias
```
docker run --rm -it --name gitmrc -v $PWD:/workspace -v ~/Documents:/config -t gitmr --lab -t target_branch -s source_branch -a assignee_user -l labels -m title --wip
```

### Docker with alias
```
your_alias --lab -t target_branch -s source_branch -a assignee_user -l labels -m title --wip
```

---

# Dependencies
* NodeJs
* Git
* Curl
* jq
* Bash
* Docker

---

# Comming features
> Add support for github ==> in progress<br/>
> Update linux installer to a faster and more stable version ==> done<br/>
> Create windows installer ==> not yet<br/>
> Create a bash command to uninstall Git-MR on linux ==> in progress<br/>
> Create a bash command to update the config file, rather than updating it manually by the user ==> done<br/>
> Create Git-MR logo ==> done<br/>
> Cronjob to notify the users when a new release come out<br/>
> NodeJs menu list ==> in progress<br/>
> Support for multiple projects at once (no need to do: git mr --config to switch between projects) ==> not yet<br/>

<strong>GitMR project - 2020</strong>
