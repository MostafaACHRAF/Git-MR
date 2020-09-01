# What it is Git-MR?
Git-MR is a git command to create git merge requests from the terminal.
The actual version support Gitlab only, we will support Github as well, in the near future.

This tool is available on all Linux distributions. We may support windows in the futrure releases.

> The idea behind Git-MR, is that you don't have to leave your terminal to submit your merge requests, everything can be done via the terminal.

---

# How to install it?
Copy page this command to install GitMR

> $ sudo git clone https://github.com/MostafaACHRAF/Git-MR /bin/GitMR && sudo chmod +x /bin/GitMR/*.sh && .linux-install.sh

---

# How it works?

*Now, the terminal, and cmd will recognize git lmr as a git command.\
*The command is :\
*git lmr <remote_branch [default=dev]>, if you didn't type anything after 'lmr', then a new MR will be created in (DEV or master) branch\
*Then the command will ask you two questions :\
*1) assignee_id : (type the id of the person who will accept your MR, by default the MR will be assigned to you)\
*2) labels : (give the identifiers of some labels separated by ','). Example : java,bugFixing,test\
*The title of the last commit is the title of your merge request\
*After that you will have a confirmation message, answer with : [y/n]\
*If everything works fine, you will be redirected automatically to your gitlab account to view your merge request details\



---

# Dependencies


---

# Comming features
> Add support for github
> Update linux installer to a faster and more stable version
> Create windows installer
> Create a bash command to update Git-MR, and notify the users if a new version is released
> Create a bash command to uninstall Git-MR on linux
> Create a bash command to update the config file, rather than updating it manually by the user
> Create Git-MR logo