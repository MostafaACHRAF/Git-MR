![gitmr-logo](./gitmr-logo-200x200.png)

Give me a star!🌟

---

# What it is Git-MR?
A git command to create git merge requests from the terminal.<br/>
It's a more elegant way to create merge requests on github and gitlab.<br/>
Git-MR is a fast, safe, and elegant.<br/>

* Git-MR comes in tow flavors:
1- Installable version
2- Docker image

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
docker run --rm -it --name gitmrc -v $PWD:/workspace -v ${CONF_DIR}:/config -t gitmr:latest
```
* ${CONF_DIR}: is where gitmr will store and read it's configuration. You must provide a value for this parameter
* ${PWD}: The actual folder will be mounted in workspace folder. The workspace represents your gitlab/github local repository. You can leave this parameter as it is, or change it.

---

Or you can create an alias, copy paste this line into your shell configuration file (~/.bashrc, ~/.zshrc...):<br/>
```
alias gmra="docker run --rm -it --name gmr -v $PWD:/workspace -v ${CONF_DIR}:/conf -t gitmr:latest"
```

To test your installation run this command:<br/>
```
git mr --version
```

---

# How to use it?
After installing the tool on your machine. You can use 'git mr' as a terminal command.<br/>
The way of use depends on installation type:<br/>

### Normal installation:
```
git mr -in ${PROJECT_ALIAS} -t ${TARGET_PROJECT} -s ${SOURCE_PROJECT} -a ${ASSIGNEE_USER} -l ${LABELS} -m ${TITLE} --wip
```

### Docker without alias
```
docker run --rm -it --name gitmrc -v $PWD:/workspace -v ${CONF_DIR}:/conf -t gitmr -in ${PROJECT_ALIAS} -t ${TARGET_BRANCH} -s ${SOURCE_BRANCH} -a ${ASSIGNEE_USER} -l ${LABELS} -m ${TITLE} --wip
```

### Docker with alias
```
${ALIAS} -in ${PROJECT_NAME} -t ${TARGET_BRANCH} -s ${SOURCE_BRANCH} -a ${ASSIGNEE_USER} -l ${LABELS} -m ${TITLE} --wip
```

---

# Dependencies
* NodeJs
* npm
* Git
* Curl
* jq
* Bash
* Docker

---

# Options

## Note
- One dash means that this option has paramerters. Example: -in ${ALIAS}
- Two dashes means that this option has no parameters. Example: --ls
- Option's paramters are mandatory, if they exist!
- Options order isn't important. For example the following two commads are valid: 
```
git mr -t ${TARGET_BRANCH} -in ${ALIAS}
```
```
git mr -in ${ALIAS} -t ${TARGET_BRANCH}
```

Option | Parameters       | Mandatory | Description                        | Default
------ | ---------------- | --------- | ---------------------------------- | --------------------------
-in    |  ${ALIAS}        |   Yes     |    Git project's alias<br\>        |
       |                  |           |    in which this merge request<br/>| 
       |                  |           |    will be created                 |
------ | ---------------- | --------- | ---------------------------------- | --------------------------
-s       ${SOURCE_BRANCH}   No           Source branch                     Actual local branch
------ | ---------------- | --------- | -------------------------------- | --------------------------
-t       ${TARGET_BRANCH}   Yes          Target branch
------ | ---------------- | --------- | -------------------------------- | --------------------------
-a       ${ASSIGNEE_USER}   No           Assignee user.<br/>               Actual configured git user
                                         To whom this MR will be assigned
------ | ---------------- | --------- | -------------------------------- | --------------------------
-m       ${TITLE}           No          Merge request title                Head commit title
------ | ---------------- | --------- | -------------------------------- | --------------------------
-l       ${LABELS}          No          Merge request labels<br/>
                                        Separated by ","
------ | ---------------- | --------- | -------------------------------- | --------------------------
--wip                       No          Makes that MR's state:<br/>
                                        "Work in progress"
------ | ---------------- | --------- | -------------------------------- | --------------------------
--cnf                       No          Configure or update git<br/>
                                        project's alias.<br/>
                                        Write configuration into<br/>
                                        "conf/git.projects"
------ | ---------------- | --------- | -------------------------------- | --------------------------
--ls                        No          List all git alias found in<br/>
                                        "conf/git.projects"
------ | ---------------- | --------- | -------------------------------- | --------------------------
-show    ${ALIAS}           No          Show details of one alias<br/>
                                        Like: name, token, repo,...
------ | ---------------- | --------- | -------------------------------- | --------------------------
--v                         No          display "gitmr" version
------ | ---------------- | --------- | -------------------------------- | --------------------------
--h                         No          Get help
------ | ---------------- | --------- | -------------------------------- | --------------------------
-rm      ${ALIAS}           No          Remove one alias from:<br/>
                                        "conf/git.projects"
------ | ---------------- | --------- | -------------------------------- | --------------------------
--rm                        No          Remove all alias
------ | ---------------- | --------- | -------------------------------- | --------------------------
--purge                     No          Uninstall "gitmr"

---

# Comming features
> Add support for github ==> done<br/>
> Update linux installer to a faster and more stable version ==> done<br/>
> Create a bash command to uninstall Git-MR on linux ==> done<br/>
> Create a bash command to update the config file, rather than updating it manually by the user ==> done<br/>
> Create Git-MR logo ==> done<br/>
> Cronjob to notify the users when a new release come out ==> not yet<br/>
> NodeJs menu list ==> done<br/>
> Support for multiple projects at once (no need to do: git mr --cnf to switch between projects) ==> done<br/>

<strong>GitMR project - 2020</strong>
